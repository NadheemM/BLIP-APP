import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Current authenticated user (null if not logged in).
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes for reactive UI updates.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Signs in with Google. On web uses signInWithPopup; on mobile uses
  /// the google_sign_in package for native flow.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // Web: Use Firebase Auth popup directly (no client ID needed)
        final provider = GoogleAuthProvider();
        provider.addScope('email');
        provider.addScope('profile');
        userCredential = await _auth.signInWithPopup(provider);
      } else {
        // Mobile: Use Google Sign-In package
        final GoogleSignInAccount? account = await _googleSignIn.signIn();
        if (account == null) return null; // User cancelled

        final GoogleSignInAuthentication auth = await account.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        );
        userCredential = await _auth.signInWithCredential(credential);
      }

      // Store / update user info in Firestore
      await _storeUserInfo(userCredential.user!);

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  /// Stores user info in 'users' collection on each login.
  Future<void> _storeUserInfo(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'displayName': user.displayName ?? 'Anonymous',
      'email': user.email ?? '',
      'photoURL': user.photoURL ?? '',
      'lastLogin': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Updates the user's FCM token in Firestore.
  Future<void> updateFcmToken(String token) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'fcmToken': token,
    });
  }

  /// Signs out from both Google and Firebase.
  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
