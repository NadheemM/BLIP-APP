/**
 * Cloud Function: sendChatNotification
 *
 * Triggered when a new message is added to the 'messages' collection.
 * Sends an FCM push notification to all other users who have an FCM token stored.
 *
 * DEPLOYMENT:
 *   1. Install Firebase CLI: npm install -g firebase-tools
 *   2. Login: firebase login
 *   3. Init functions: firebase init functions (select your project)
 *   4. Copy this file and package.json to the functions/ directory
 *   5. cd functions && npm install
 *   6. Deploy: firebase deploy --only functions
 *
 * NOTE: Cloud Functions require the Blaze (pay-as-you-go) plan.
 *       The free Spark plan does NOT support Cloud Functions.
 */

const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

exports.sendChatNotification = onDocumentCreated(
  "messages/{messageId}",
  async (event) => {
    const message = event.data.data();

    if (!message) {
      console.log("No message data found");
      return;
    }

    const senderUid = message.senderUid;
    const senderName = message.sender || "Someone";
    const messageText = message.text || "";

    try {
      // Get all users except the sender
      const usersSnapshot = await getFirestore()
        .collection("users")
        .get();

      const tokens = [];
      usersSnapshot.forEach((doc) => {
        const userData = doc.data();
        // Only send to other users who have an FCM token
        if (userData.uid !== senderUid && userData.fcmToken) {
          tokens.push(userData.fcmToken);
        }
      });

      if (tokens.length === 0) {
        console.log("No tokens to send notifications to");
        return;
      }

      // Send notification to all collected tokens
      const response = await getMessaging().sendEachForMulticast({
        tokens: tokens,
        notification: {
          title: senderName,
          body: messageText.length > 100
            ? messageText.substring(0, 100) + "..."
            : messageText,
        },
        data: {
          type: "chat_message",
          senderUid: senderUid,
          senderName: senderName,
        },
        // Android-specific config
        android: {
          notification: {
            channelId: "blip_chat_channel",
            priority: "high",
            defaultSound: true,
          },
        },
        // iOS-specific config
        apns: {
          payload: {
            aps: {
              sound: "default",
              badge: 1,
            },
          },
        },
        // Web-specific config
        webpush: {
          notification: {
            icon: "/icons/Icon-192.png",
          },
        },
      });

      console.log(
        `Notifications sent: ${response.successCount} success, ${response.failureCount} failure`
      );

      // Clean up invalid tokens
      if (response.failureCount > 0) {
        const failedTokens = [];
        response.responses.forEach((resp, idx) => {
          if (!resp.success) {
            failedTokens.push(tokens[idx]);
          }
        });
        console.log("Failed tokens:", failedTokens);
      }
    } catch (error) {
      console.error("Error sending notifications:", error);
    }
  }
);
