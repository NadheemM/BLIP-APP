import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'auth_service.dart';

/// Top-level background handler for FCM (required to be top-level).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background messages are handled automatically by the system notification tray.
  // No additional logic needed here unless you want to process data.
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'blip_chat_channel',
    'Blip Chat Messages',
    description: 'Notifications for new chat messages in Blip',
    importance: Importance.high,
    playSound: true,
  );

  /// Initialize FCM and local notifications.
  static Future<void> initialize() async {
    // Register the background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permission (iOS + web)
    await _requestPermission();

    // Initialize local notifications for foreground (mobile only)
    if (!kIsWeb) {
      await _initLocalNotifications();
    }

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Get and store FCM token
    await _getAndStoreToken();

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((token) async {
      await AuthService().updateFcmToken(token);
    });
  }

  /// Request notification permissions.
  static Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  /// Initialize flutter_local_notifications for Android/iOS.
  static Future<void> _initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _localNotifications.initialize(initSettings);

    // Create the Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  /// Handle foreground messages — show a local notification banner.
  static void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    if (!kIsWeb) {
      _localNotifications.show(
        notification.hashCode,
        notification.title ?? 'Blip',
        notification.body ?? 'New message',
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    }
  }

  /// Get the FCM token and store it in Firestore.
  static Future<void> _getAndStoreToken() async {
    try {
      String? token;
      if (kIsWeb) {
        // For web, you may need a VAPID key. Using getToken without for now.
        token = await _messaging.getToken();
      } else {
        token = await _messaging.getToken();
      }

      if (token != null) {
        await AuthService().updateFcmToken(token);
      }
    } catch (e) {
      // Token retrieval may fail on some platforms (e.g. web without VAPID key)
      // Silently handle — notifications just won't work for this user.
    }
  }

  /// Manually refresh and store FCM token (call after login).
  static Future<void> refreshToken() async {
    await _getAndStoreToken();
  }
}
