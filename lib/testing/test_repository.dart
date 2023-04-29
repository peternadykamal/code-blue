import 'package:geolocator/geolocator.dart';
import 'package:gradproject/repository//user_repository.dart';
import 'package:gradproject/services/auth_service.dart';
import 'package:gradproject/utils/has_network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradproject/repository/relation_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gradproject/utils/user_geolocation.dart';

Future<void> testThis() async {
  // UserProfile user = UserProfile(email: "hell@gmail.com", username: "hello");
  // await UserRepository().updateUserProfile(user); final list = await
  // UserRepository().fuzzyUserEmailSearch("hel"); print(list); await
  // withInternetConnection([ () => AuthService() .signInWithEmail(email:
  // 'hell@yahoo.com', password: '123456'), ]); await
  //   AuthService().resetPassword(); await
  //       AuthService().verifyPhoneNumber("+201204290582");

  // await RelationRepository().addRelation("mOWCpqtfbKenJvEblEXEBTgy1uP2");
  // final relation = Relation( userId1: 'sF6ja62XSTbToHzMih4HrbrMfgL2',
  //     userId2: 'ZidAyWx9HVafLj48IqBLtuMAqTp2'); final relationMap =
  //     Relation.fromRelationsToMap(relation); await FirebaseDatabase.instance
  // .ref() .child('relations') .push() .set(relationMap);

  // List<Relation> list = await
  // RelationRepository().getRelationsForCurrentUser();

  // print(list[0].userId1 + " " + list[0].userId2 + " " +
  // list[0].id.toString()); print(list[1].userId1 + " " + list[1].userId2 + " "
  // + list[1].id.toString()); print(list[2].userId1 + " " + list[2].userId2 + "
  // " + list[2].id.toString());

  // RelationRepository().deleteRelation(list[2].id.toString());

  // List<Relation> list1 = await
  //     RelationRepository().getRelationsForCurrentUser(); print(list1.length);

  // print(await UserRepository().getUserIdByEmail('nady.peter347@gmail.com'));
  // print(user.username); print(user.email); print(user.profileImageUrl);
  // print(user.medicalCondition);
}
