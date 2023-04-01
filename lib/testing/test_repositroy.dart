import 'package:gradproject/repository//user_repository.dart';

Future<void> testThis() async {
  UserProfile user = UserProfile(email: "hell@gmail.com");
  await UserRepository().updateUserProfile(user);
  final list = await UserRepository().fuzzyUserEmailSearch("hel");
  print(list);
}
