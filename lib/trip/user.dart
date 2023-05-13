import 'package:firebase_database/firebase_database.dart';

class User1{
  String? username ;
  String? email ;
  String? phoneNumber ;
  String? id ;

  User1(
    {
    this.username,
    this.email,
    this.phoneNumber,
    this.id,

    }
      );

  User1.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    final data = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
    username = data['username'];
    email = data['email'];
    phoneNumber = data['phoneNumber'];
  }

}
