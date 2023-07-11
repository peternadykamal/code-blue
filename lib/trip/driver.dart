import 'package:firebase_database/firebase_database.dart';

class Driver{

  String? id;
  String? hospitalLat;
  String? hospitalLong;
  String? hospitalName;
  String? ambulances;

  Driver({

    this.id,
    this.hospitalName,
    this.ambulances,
    this.hospitalLat,
    this.hospitalLong,

  });











  Driver.fromSnapshot(DataSnapshot snapshot){
    dynamic cat = snapshot.value;
    id = snapshot.key;
    hospitalName = cat['Hospitalname'];
    ambulances = cat['Ambulances'];
    hospitalLat = cat['Location'] ['Lat'];
    hospitalLong = cat['Location'] ['Long'];

  }

}