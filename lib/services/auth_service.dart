import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:gradproject/services/fcm_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gradproject/utils/has_network.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/repository/relation_repository.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _onAuthStateChanged(User? user) async {
    if (user != null) {
      print('User signed in: ${user.uid}');

      if (await isNetworkAvailable()) {
        //update fcm token
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        fcmToken != null
            ? await UserRepository().updateFcmToken(fcmToken)
            : null;

        // save phone numbers of caregivers in shared preferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        List<Relation> list = (await RelationRepository()
            .getRelationsForCurrentUser())['relations'];
        List<String> phoneNumbers = [];
        for (Relation relation in list) {
          UserProfile user =
              await UserRepository().getUserById(relation.userId2);
          phoneNumbers.add(user.phoneNumber);
        }
        prefs.setStringList('caregiversPhoneNumbers', phoneNumbers);

        // save user profile locally
        if (user.photoURL != null) {
          final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
          final Reference reference =
              _firebaseStorage.refFromURL(user.photoURL!);
          final data = await reference.getData();
          // store image locally
          final Directory tempDir = Directory.systemTemp;
          // check if user id directory exists
          final Directory userDir = Directory('${tempDir.path}/${user.uid}');
          if (!await userDir.exists()) {
            await userDir.create();
          }
          final File tempImage =
              await File('${tempDir.path}/${user.uid}/profile.png').create();
          await tempImage.writeAsBytes(data!);
        }
      }

      // how to get phone numbers final SharedPreferences prefs = await
      // SharedPreferences.getInstance(); List<String> phoneNumbers =
      // prefs.getStringList('caregiversPhoneNumbers') ?? [];
      //     print(phoneNumbers);

      await FcmService().initialize();
    } else {
      print('User signed out.');
    }
  }

  // signOut user
  Future<void> signOut() async {
    await UserRepository().deleteFcmToken();
    await _auth.signOut();
  }

  /// delete user
  /// ```dart
  /// AuthService().deleteUser();
  /// ```
  /// returns true if user is deleted returns false if user is not deleted
  /// returns false if user is null returns false if user is not deleted
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
  /// returns user if user is signed in returns null if user is not signed in
  /// returns null if user is not found returns null if password is wrong
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
  /// returns user if user is signed up returns null if error signing up
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

  /// to verify phone number
  /// ```dart
  ///void _verifyPhoneNumber() async {
  ///   await signUpAndVerifyPhoneNumber(
  ///     emailController.text.trim(),
  ///     passwordController.text.trim(),
  ///     phoneNumberController.text.trim(),
  ///     onVerificationCompleted: (user) {
  ///       // Handle successful phone number verification and update UI
  ///       setState(() {
  ///         // Update UI using user data
  ///       });
  ///     },
  ///     onVerificationFailed: (authException) {
  ///       // Handle phone number verification failure
  ///     },
  ///     onCodeSent: (verificationId, forceResendingToken)async {
  ///     // Update the UI - wait for the user to enter the SMS code
  ///     String smsCode = 'xxxx';

  ///     // Create a PhoneAuthCredential with the code PhoneAuthCredential
  ///     credential = PhoneAuthProvider.credential(verificationId:
  ///     verificationId, smsCode: smsCode);

  ///    // Sign the user in (or link) with the credential await
  ///     auth.signInWithCredential(credential); }, onCodeAutoRetrievalTimeout:
  ///    (verificationId) { // Handle code auto retrieval timeout event and
  ///     update UI },
  ///   );
  /// }
  /// ```
  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    Function(User)? onVerificationCompleted,
    Function(FirebaseAuthException)? onVerificationFailed,
    Function(String, [int])? onCodeSent,
    Function(String)? onCodeAutoRetrievalTimeout,
  }) async {
    // Verify phone number
    PhoneVerificationCompleted verificationCompleted =
        onVerificationCompleted != null
            ? (PhoneAuthCredential phoneAuthCredential) async {
                await FirebaseAuth.instance
                    .signInWithCredential(phoneAuthCredential);
                onVerificationCompleted(_auth.currentUser!);
              }
            : (PhoneAuthCredential phoneAuthCredential) async {
                await FirebaseAuth.instance
                    .signInWithCredential(phoneAuthCredential);
                print(
                    "Phone number automatically verified and signed in: ${_auth.currentUser?.uid}");
              };
    PhoneVerificationFailed verificationFailed = onVerificationFailed != null
        ? (FirebaseAuthException authException) {
            onVerificationFailed(authException);
          }
        : (FirebaseAuthException authException) {
            if (authException.code == 'invalid-phone-number') {
              print(
                  'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
            }
          };

    PhoneCodeSent codeSent = onCodeSent != null
        ? (String verificationId, [int? forceResendingToken]) async {
            onCodeSent(verificationId, forceResendingToken!);
          }
        : (String verificationId, [int? forceResendingToken]) async {
            print(
                'Please check your phone for the verification code. Code: $verificationId');
          };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        onCodeAutoRetrievalTimeout != null
            ? (String verificationId) {
                onCodeAutoRetrievalTimeout(verificationId);
              }
            : (String verificationId) {
                print("Verification code auto retrieval timed out.");
              };

    // Start phone number verification
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 60));
  }

  /// to reset password returns true if password is reset returns false if error
  /// resetting password
  Future<bool> resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _auth.currentUser!.email!);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> forgetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void initialize() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }
}
