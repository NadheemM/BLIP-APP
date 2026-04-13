// Firebase messaging service worker for web notifications.
// This file must be at the root of the web directory.
importScripts("https://www.gstatic.com/firebasejs/10.12.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.12.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyCF6E2RF87AQoyGgTX1bPnYBTC1tnJykBs",
  authDomain: "blip-373e6.firebaseapp.com",
  projectId: "blip-373e6",
  storageBucket: "blip-373e6.firebasestorage.app",
  messagingSenderId: "555921293464",
  appId: "1:555921293464:web:d247293e9cfeee3929d0ed",
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((message) => {
  console.log("[firebase-messaging-sw.js] Background message received:", message);

  const notificationTitle = message.notification?.title || "Blip";
  const notificationOptions = {
    body: message.notification?.body || "New message",
    icon: "/icons/Icon-192.png",
    badge: "/icons/Icon-192.png",
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});
