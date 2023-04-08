import 'package:gradproject/repository//user_repository.dart';

Future<void> testThis() async {
  UserProfile user = UserProfile(email: "hell@gmail.com", username: "hello");
  await UserRepository().updateUserProfile(user);
  final list = await UserRepository().fuzzyUserEmailSearch("hel");
  print(list);
}
