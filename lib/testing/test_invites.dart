import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gradproject/repository/invite_repository.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/utils/has_network.dart';
import 'package:gradproject/repository/relation_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

testThis() async {
  // await InvitesRepository().createInvitation('EW8b3b45opeRjRuk5uvFJoXVNEO2');
  // await InvitesRepository().createInvitation('zrl4DQgjwRQ9KKpl1KnZjB9J37h2');
  // await InvitesRepository()
  //     .updateInviteStatus('-NU0ysNx5J54thbghM7Q', InviteStatus.rejected);
  // final results = await withInternetConnection(
  //     [() => InvitesRepository().acceptInvitation('-NU1DjoSbwqF0x2wtaA3')]);
  // for (dynamic object in results) {
  //   if (object is bool) {
  //     print(object);
  //   }
  // }

  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  // List<String> phoneNumbers =
  //     prefs.getStringList('caregiversPhoneNumbers') ?? [];
  // print(phoneNumbers);
}
