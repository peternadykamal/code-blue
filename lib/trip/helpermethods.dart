
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gradproject/trip/address.dart';
import 'package:gradproject/trip/appdata.dart';
import 'package:gradproject/trip/requesthelper.dart';
import 'package:gradproject/trip/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import '../globalvariables.dart';


class HelperMethods {

  static void getCurrentUserInfo() async {
    currentFirebaseUser =  await FirebaseAuth.instance.currentUser;

    String? userid= currentFirebaseUser?.uid;

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/${userid}');

    userRef.once().then((DatabaseEvent databaseEvent) async {
      //final dataSnapshot = databaseEvent.snapshot;
      final snapshot= await userRef.get();
        //print('Outside IF');
      if (snapshot.value != null ){
        //print('Inside IF');

         currentUserInfo = User1.fromSnapshot(snapshot);
         print('Accessing UserInfo Successfully');
         print('my name is ${currentUserInfo!.username}');
        // print('my email is ${currentUserInfo!.email}');
        // print('my phone is ${currentUserInfo!.phoneNumber}');
        // print('ID is ${currentUserInfo!.id}');
      }

    }).catchError((error) {
      // Handle errors here
      print('Error getting user information: $error');
    });

  }


  static Future<String> findCordinateAddress( Position position, context) async {

    String placeAddress = '';

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
      return placeAddress;
    }

    //String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyC6jY0krNZFE-AaXG7hSdeEvYgA-YiV_bc';


    //var response = await  RequestHelper.getRequest(url);


    if (position != null){
      //placeAddress = response['results'][0]['formatted_address'];

      Address pickupAddress = new Address();
      pickupAddress.longitude = position.longitude;
      pickupAddress.latitude = position.latitude;
      //pickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickupAddress(pickupAddress);

    }


    return placeAddress;
  }




  static double generateRandomNumber (int max){

    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();

  }





}