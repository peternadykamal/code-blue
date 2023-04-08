import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradproject/services/fcm_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _onAuthStateChanged(User? user) {
    if (user != null) {
      // print('User signed in: ${user.uid}');
      FcmService().initialize();
    } else {
      print('User signed out.');
    }
  }

  // signOut user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// delete user
  /// ```dart
  /// AuthService().deleteUser();
  /// ```
  /// returns true if user is deleted
  /// returns false if user is not deleted
  /// returns false if user is null
  /// returns false if user is not deleted
  Future<bool> deleteUser() async {
    if (_auth.currentUser != null) {
      try {
        await _auth.currentUser!.delete();
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
  }

  /// to sign in with email and password
  /// ```dart
  /// AuthService().signInWithEmail(email, password);
  /// ```
  /// returns user if user is signed in
  /// returns null if user is not signed in
  /// returns null if user is not found
  /// returns null if password is wrong
  Future<User?> signInWithEmail(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return null;
      } else {
        print('Error signing in with email and password: $e');
        return null;
      }
    }
  }

  /// to sign up with email and password
  /// ```dart
  /// AuthService().signUpWithEmail(email, password);
  /// ```
  /// returns user if user is signed up
  /// returns null if error signing up
  Future<User?> signUpWithEmail(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error signing up with email and password: $e');
      return null;
    }
  }

  void initialize() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }
}
