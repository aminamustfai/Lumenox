import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// Wraps every auth call used by the Register / Login / Forgot-Password /
/// Reset-Password screens. Keep ALL Firebase calls here so the UI stays clean.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Screen 2 -> 3: "Create Your Lumenox Account" -> "Registered successfully"
  Future<User?> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;
    if (user == null) return null;

    // Save the extra profile fields Firebase Auth doesn't store (fullName etc.)
    await _db.collection('users').doc(user.uid).set(
          UserModel(
            uid: user.uid,
            fullName: fullName.trim(),
            email: email.trim(),
            createdAt: DateTime.now(),
          ).toMap(),
        );

    await user.updateDisplayName(fullName.trim());
    await user.sendEmailVerification(); // triggers "Please check your email" screen
    return user;
  }

  /// Screen 4: "Welcome Back" -> Log In
  Future<User?> login({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  /// Call after login if you want to hard-block unverified users.
  Future<bool> isEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<void> resendVerificationEmail() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  /// Screen 5 -> 6: "We've got your back" -> "Sent successfully"
  /// Sends the reset link. NOTE (important, read below): by default this
  /// link opens Firebase's own hosted web page, not your app. See the
  /// FIRESTORE_SETUP.md notes on Dynamic Links / action code settings if you
  /// want the "Reset your password" screen (image 7) to open *inside* the
  /// app instead of a browser.
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Screen 7: "Reset your password" — only usable if you intercepted the
  /// oobCode from the email deep link and pass it in here.
  Future<void> confirmPasswordReset({
    required String oobCode,
    required String newPassword,
  }) async {
    await _auth.confirmPasswordReset(code: oobCode, newPassword: newPassword);
  }

  Future<void> signOut() => _auth.signOut();
}
