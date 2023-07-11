import 'package:firebase_database/firebase_database.dart';

class Hospital{

 double? hospitalLat;
 double? hospitalLng;

  Hospital({
   this.hospitalLat,
   this.hospitalLng

  });











  Hospital.fromSnapshot(DataSnapshot snapshot){
    dynamic cat = snapshot.value;

    hospitalLat = cat['l']['0'];
    hospitalLng=  cat['l']['1'];


  }

}