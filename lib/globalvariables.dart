import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradproject/trip/driver.dart';
import 'package:gradproject/trip/user.dart';
//import '../datamodels/user.dart';

User? currentFirebaseUser;

User1? currentUserInfo;

//String serverKey = 'key=AAAAjFe2lDQ:APA91bEfiszoRCp6d7VL8cWkwLwWcn1X87_HdTGaHcGy-PkRPfy63vrgN3FHISsoizS9VuHTOa5coPX_b6qYGuo_DA-HBRmw05Ay6fK54xsvbtBPvWNslXkaEWUj3mUNJvsYXk-TcM0s';

String status ='' ;

String driverCarNumber ='';

String driverFullName = '';

String driverPhone ='';

LatLng? driverLocation;

String tripStatusDisplay = 'Help is Coming';
Driver? currentDriverInfo;

//StreamSubscription<Position>? driverPositionStream ;

//late Position driverPosition;