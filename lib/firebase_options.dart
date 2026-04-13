// File generated manually with Firebase project config.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCF6E2RF87AQoyGgTX1bPnYBTC1tnJykBs',
    appId: '1:555921293464:web:d247293e9cfeee3929d0ed',
    messagingSenderId: '555921293464',
    projectId: 'blip-373e6',
    authDomain: 'blip-373e6.firebaseapp.com',
    storageBucket: 'blip-373e6.firebasestorage.app',
    measurementId: 'G-E4CBQPSGMC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCF6E2RF87AQoyGgTX1bPnYBTC1tnJykBs',
    appId: '1:555921293464:web:d247293e9cfeee3929d0ed',
    messagingSenderId: '555921293464',
    projectId: 'blip-373e6',
    storageBucket: 'blip-373e6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCF6E2RF87AQoyGgTX1bPnYBTC1tnJykBs',
    appId: '1:555921293464:web:d247293e9cfeee3929d0ed',
    messagingSenderId: '555921293464',
    projectId: 'blip-373e6',
    storageBucket: 'blip-373e6.firebasestorage.app',
    iosBundleId: 'com.blip.blip',
  );
}
