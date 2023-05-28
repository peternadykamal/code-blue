import 'package:firebase_database/firebase_database.dart';

class Driver{
  // String? fullName;
  // String? email;
  // String? phone;
  String? id;
  // String? vehicleNumber;
  String? hospitalName;
  String? ambulances;

  Driver({
    // this.fullName,
    // this.email,
    // this.phone,
    this.id,
    this.hospitalName,
    this.ambulances,
    // this.vehicleNumber,
  });











  Driver.fromSnapshot(DataSnapshot snapshot){
    dynamic cat = snapshot.value;
    id = snapshot.key;
    hospitalName = cat['Hospitalname'];
    ambulances = cat['Ambulances'];
    // phone = cat['phone'];
    // email = cat['email'];
    // fullName = cat['fullname'];
    // vehicleNumber = cat['vehicle_number'];
  }

}