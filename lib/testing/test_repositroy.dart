import 'package:gradproject/repository//user_repository.dart';
import 'package:gradproject/services/auth_service.dart';
import 'package:gradproject/utils/has_network.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> testThis() async {
  // UserProfile user = UserProfile(email: "hell@gmail.com", username: "hello");
  // await UserRepository().updateUserProfile(user);
  // final list = await UserRepository().fuzzyUserEmailSearch("hel");
  // print(list);
  // await withInternetConnection([
  //   () => AuthService()
  //       .signInWithEmail(email: 'hell@yahoo.com', password: '123456'),
  // ]);
  // await AuthService().resetPassword();
  await AuthService().verifyPhoneNumber("+201204290582");
}
