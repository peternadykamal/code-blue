import 'package:firebase_database/firebase_database.dart';

class Driver{
  String? fullName;
  String? email;
  String? phone;
  String? id;
  String? vehicleNumber;

  Driver({
    this.fullName,
    this.email,
    this.phone,
    this.id,
    this.vehicleNumber,
  });











  Driver.fromSnapshot(DataSnapshot snapshot){
    dynamic cat = snapshot.value;
    id = snapshot.key;
    phone = cat['phone'];
    email = cat['email'];
    fullName = cat['fullname'];
    vehicleNumber = cat['vehicle_number'];
  }

}