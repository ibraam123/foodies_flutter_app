import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb check

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Email & Password Sign In
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password.';
      } else {
        throw 'Sign in failed: ${e.message}';
      }
    } catch (e) {
      throw 'Sign in failed: ${e.toString()}';
    }
  }

  // Email & Password Sign Up
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'An account already exists for this email.';
      } else {
        throw 'Sign up failed: ${e.message}';
      }
    } catch (e) {
      throw 'Sign up failed: ${e.toString()}';
    }
  }

  // Google Sign In
  Future<User?> signInWithGoogle() async {
    try {
      // For web
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        UserCredential result = await _auth.signInWithPopup(googleProvider);
        return result.user;
      }
      // For mobile
      else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential result = await _auth.signInWithCredential(credential);
        return result.user;
      }
    } catch (e) {
      throw 'Google sign in failed: ${e.toString()}';
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw 'Password reset failed: ${e.message}';
    } catch (e) {
      throw 'Password reset failed: ${e.toString()}';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // Sign out from Google if signed in with Google
      await _auth.signOut();
    } catch (e) {
      throw 'Sign out failed: ${e.toString()}';
    }
  }
}