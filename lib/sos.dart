import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradproject/chatbot.dart';
import 'package:gradproject/loadingcontainer.dart';
import 'package:gradproject/main.dart';
import 'package:gradproject/maps.dart';
import 'package:gradproject/profile1.dart';
import 'package:gradproject/caregiversList.dart';
import 'package:gradproject/repository/request_repository.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/translations/locale_keys.g.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/trip/DriverAssignedDetails.dart';
import 'package:gradproject/trip/appdata.dart';
import 'package:gradproject/trip/driver.dart';
import 'package:gradproject/trip/firehelper.dart';
import 'package:gradproject/trip/helpermethods.dart';
import 'package:gradproject/trip/nearbydriver.dart';
import 'package:gradproject/trip/showMap.dart';
import 'package:gradproject/trip/tripdetails.dart';
import 'package:gradproject/trip/user.dart';
import 'package:gradproject/utils/has_network.dart';
import 'package:gradproject/notificationList.dart';
import 'package:gradproject/repository/notification_repository.dart'
    as notifyRepo;
import 'package:provider/provider.dart';

import 'globalvariables.dart';

class sosPage extends StatefulWidget {



  const sosPage({super.key});


  @override
  State<sosPage> createState() => _sosPageState();
}

class _sosPageState extends State<sosPage> {
  late Position currentPosition;
  bool? hasNewNotification;
  UserProfile? user;
  DatabaseReference? rideRef;
  List <NearbyDriver> ?availableDrivers;
  StreamSubscription<DatabaseEvent> ?rideSubscription;
  bool nearbyDriversKeysLoaded = false;
  DriverAssignedDetails details = DriverAssignedDetails();


  void setupPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    print('This is current location Lat ${currentPosition.latitude.toString()}');
    print('This is current location Lng ${currentPosition.longitude.toString()}');
    //print('CURRENT USERNAME ${currentUserInfo!.username}');
    startGeofireListener();


  }

  void createRideRequest(){
    //print('CURRENT USERNAME ${currentUserInfo!.username}');
    rideRef = FirebaseDatabase.instance.reference().child('rideRequest').push();

    // var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;

    Map pickupMap = {
      'latitude':currentPosition.latitude.toString(),
      'longitude':currentPosition.longitude.toString(),
    };


    Map rideMap = {
      'created_at': DateTime.now().toString(),
      'rider_name': currentUserInfo?.username,
      'rider_phone': currentUserInfo?.phoneNumber,
      //'pickup_address': pickup.placeName,
      'location': pickupMap,

    };


    rideRef?.set(rideMap);
    print('RideRequested Check firebase');
    print(rideMap);

    // rideSubscription = rideRef?.onValue.listen((event) async {
    //
    //   //check for null snapshot
    //
    //   dynamic rideData = event.snapshot.value;
    //   if(rideData == null){
    //     return;
    //
    //   }
    //   // Get Driver Name
    //   if(rideData['driver_name'] != null){
    //     driverFullName = rideData['driver_name'].toString();
    //     print('Driver Name is:  ${driverFullName}');
    //
    //   }
    //   // Get Driver Phone
    //   if(rideData['driver_phone'] != null){
    //     driverPhone = rideData['driver_phone'].toString();
    //     print('Driver mobile number is:  ${driverPhone}');
    //
    //   }
    //   // Get Driver Vehicle Details
    //   if(rideData['vehicle_details'] != null){
    //     driverCarNumber = rideData['vehicle_details'].toString();
    //     print('vehicle number = ${driverCarNumber}');
    //
    //   }
    //   //Get and Use Driver Location Updates
    //   if(rideData['driver_location'] != null){
    //
    //     double driverLat = double.parse(rideData['driver_location']['latitude'].toString());
    //     double driverLng = double.parse(rideData['driver_location']['longitude'].toString());
    //
    //     print('Driver Latitude = ${driverLat}');
    //     print('Driver Longitude = ${driverLng}');
    //
    //     LatLng driverLocation =LatLng(driverLat, driverLng);
    //
    //     if(status == 'going'){
    //
    //     }
    //
    //   }
    //
    //
    //
    //   if (rideData['status'] != null){
    //     status = rideData['status'].toString();
    //
    //   }
    //
    //
    //   if(status == 'accepted'){
    //   }
    //
    //   if(status == 'picked'){
    //   }
    //
    //
    // });



  }
  void findDriver(){

    if(availableDrivers?.length == 0){
      //No Driver
      print('NO DRIVER AVAILABLE');
      return;
    }


    var driver = availableDrivers?[0];
    DatabaseReference driverTripRef = FirebaseDatabase.instance.reference().child('Hospitals/${driver?.key}/newRequest');
    driverTripRef?.set(rideRef?.key);

    // Update the number of ambulances
    DatabaseReference ambulanceRef = FirebaseDatabase.instance.reference()
        .child('Hospitals/${driver?.key}/Ambulances');
    ambulanceRef.once().then((DatabaseEvent databaseEvent) async {

      //final snapshot2= await ambulanceRef.get();
      dynamic rideData3=databaseEvent.snapshot.value;

      int currentAmbulances = int.tryParse(rideData3.toString()) ?? 0;
      int newAmbulances = currentAmbulances - 1;

      if (newAmbulances >= 0) {
        ambulanceRef.set(newAmbulances.toString());
        print("Number of ambulances updated: $newAmbulances");
      } else {
        print("Insufficient ambulances available.");
      }


    }).catchError((error) {
      // Handle errors here
    });


    getCurrentDriverInfo(driver!);


    //fetchRideInfo(rideRef?.key);



    //availableDrivers?.removeAt(0);
    print("DRIVER IS ASSIGNED");
    print(driver?.key);


  }
  void startGeofireListener() {

    Geofire.initialize('hospitalsAvailable');

    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 0.4)?.listen((map) {
      print(map);
      print('BEFORE.........');
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:

            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];
            FireHelper.nearbyDriverList.add(nearbyDriver);

            if(nearbyDriversKeysLoaded){
              //updateDriversOnMap();
              print('NearbyDriverKeys is Loaded');
            }

            break;

          case Geofire.onKeyExited:
            FireHelper.removeFromList(map['key']);
            //updateDriversOnMap();
            break;

          case Geofire.onKeyMoved:
          // Update your key's location
            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];

            FireHelper.updateNearbyLocation(nearbyDriver);

            //updateDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
          // All Intial Data is loaded
          //print(map['result']);

            print('Firehelper length: ${FireHelper.nearbyDriverList.length}');


            nearbyDriversKeysLoaded = true;
            //updateDriversOnMap();
            break;
        }
      }

      // setState(() {});

      if (mounted){
        setState(() {});
      }


    });
  }
  void getCurrentDriverInfo (NearbyDriver driver) async {


    DatabaseReference driverRef = FirebaseDatabase.instance.reference().child('Hospitals/${driver.key}');

    driverRef?.once().then((DatabaseEvent databaseEvent) async {


      dynamic rideData=databaseEvent.snapshot.value;

      if (rideData != null) {


        currentDriverInfo = Driver.fromSnapshot(databaseEvent.snapshot);
        print('getCurrentDriverInfo is working ........');
        // print(currentDriverInfo?.fullName);
        print(currentDriverInfo?.id);
        print(currentDriverInfo?.hospitalName);

        // print(currentDriverInfo?.phone);
        // print(currentDriverInfo?.vehicleNumber);
        acceptTrip(rideRef?.key);

      }
      else{
        print('Snapshot is Null');
      }

    }).catchError((error) {
      // Handle errors here
      print('Error retrieving data: $error');

    });





  }



   Future <DriverAssignedDetails> acceptTrip(String? rideID ) async  {

     Completer<DriverAssignedDetails> completer = Completer<DriverAssignedDetails>();

    DatabaseReference rideRef2  =  FirebaseDatabase.instance.reference().child('rideRequest/$rideID');

    rideRef2?.child('status').set('accepted');
    // rideRef2?.child('driver_name').set(currentDriverInfo?.fullName);
    // rideRef2?.child('driver_phone').set(currentDriverInfo?.phone);
    rideRef2?.child('hospital_id').set(currentDriverInfo?.id);
    rideRef2?.child('hospital_name').set(currentDriverInfo?.hospitalName);

    // rideRef2?.child('vehicle_details').set(currentDriverInfo?.vehicleNumber);
    print('ACCEPTNG TRIP');
    print(currentDriverInfo?.hospitalName);
    // print(currentDriverInfo?.vehicleNumber);

    rideSubscription= rideRef2?.onValue.listen((event) async {

      //check for null snapshot

      dynamic rideData = event.snapshot.value;
      if (rideData == null) {
        completer.complete(null);
        return;
      }

      // Get Driver Name
      if(rideData['hospital_name'] != null){
        driverFullName = rideData['hospital_name'].toString();
        print('Driver Name is:  ${driverFullName}');

      }
      // Get Driver Phone
      if(rideData['driver_phone'] != null){
        driverPhone = rideData['driver_phone'].toString();
        print('Driver mobile number is:  ${driverPhone}');

      }
      // Get Driver Vehicle Details
      if(rideData['vehicle_details'] != null){
        driverCarNumber = rideData['vehicle_details'].toString();
        print('vehicle number = ${driverCarNumber}');

      }




      details.driverName = driverFullName;
      // details.driverPhone = driverPhone;
      // details.vehicle_Number= driverCarNumber;
      details.rideID= rideRef?.key;

      print('DRIVER ASSIGNED DETAILS IS HERE !!!!');

      print(details);
      print(details.driverName);


      if (!completer.isCompleted) {
        try {
          completer.complete(details);
        } catch (e) {
          print('Error completing completer: $e');
        }
      }

      //completer.complete(details);
    });
    print('DRIVER ASSIGNED DETAILS BEFORE RETURN !!!!');
    return completer.future;
    print(details);
    print(details.driverName);



  }

  // void fetchRideInfo(String? rideID){
  //
  //
  //
  //   DatabaseReference rideRef2 = FirebaseDatabase.instance.reference().child('rideRequest/$rideID');
  //
  //   rideRef2.once().then((DatabaseEvent databaseEvent) async {
  //     //final dataSnapshot = databaseEvent.snapshot;
  //     //final snapshot= await rideRef.get();
  //
  //
  //
  //     dynamic rideData=databaseEvent.snapshot.value;
  //     if (rideData != null) {
  //
  //
  //
  //       print('Fetched Ride Info Successfully');
  //       print(databaseEvent.snapshot.value);
  //
  //
  //
  //       double pickupLat = double.parse(rideData['location']['latitude'].toString());
  //       double pickupLng = double.parse(rideData['location']['longitude'].toString());
  //       //String pickupAddress = rideData['pickup_address'].toString();
  //       String riderName = rideData['rider_name'];
  //       String riderPhone = rideData['rider_phone'];
  //
  //       print('$pickupLat');
  //       print('$pickupLng');
  //      // print('$pickupAddress');
  //       print('$riderName');
  //       print('$riderPhone');
  //
  //       print('Trip Details will be printed after this :!!!!!!!');
  //
  //       TripDetails tripDetails = TripDetails();
  //
  //       tripDetails.rideID = rideID;
  //       //tripDetails.pickupAddress = pickupAddress;
  //       tripDetails.pickup = LatLng(pickupLat, pickupLng);
  //       tripDetails.riderName=riderName;
  //       tripDetails.riderPhone=riderPhone;
  //
  //       print(tripDetails.pickup);
  //       print(tripDetails.riderName);
  //      // print(tripDetails.pickupAddress);
  //
  //     }
  //     else{
  //       print('Snapshot is Null');
  //     }
  //
  //   }).catchError((error) {
  //     // Handle errors here
  //     print('Error retrieving data: $error');
  //
  //   });
  //
  //
  //
  //
  // }


  @override
  void initState() {
    super.initState();
    HelperMethods.getCurrentUserInfo();
    getuser();
    setupPositionLocator();
  }
  // void dispose() {
  //   GeofireListener.cancel();
  //   Geofire.removeGeoQuery('hospitalsAvailable');
  //   super.dispose();
  //
  //
  // }
  void getuser() async {
    final fetchedUser = await UserRepository().getUserProfile();
    final fetchedHasNewNotificaiton =
        await notifyRepo.NotificationRepository().hasNewNotification();
    setState(() {
      user = fetchedUser;
      hasNewNotification = fetchedHasNewNotificaiton;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return loadingContainer();
    } else {
      return SafeArea(
        child: Scaffold(
          body: Column(children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(LocaleKeys.welcomeback.tr(),
                        style: TextStyle(
                            color: Mycolors.notpressed,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Text(user!.username,
                        style: TextStyle(
                            color: Mycolors.textcolor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
                SizedBox(width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationPage(),
                          ),
                        );
                        // Navigator.push( context, MaterialPageRoute( builder:
                        //   (context) => CareGiversList(), ), );
                      },
                      child: SvgPicture.asset(
                        hasNewNotification == true
                            ? ("assets/images/notification.svg")
                            : ("assets/images/no notification.svg"),
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: user?.profileImage?.image,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profileone(),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 80),
            Center(
                child: Text(LocaleKeys.clickbuttonbelow.tr(),
                    style: TextStyle(
                        color: Mycolors.notpressed,
                        fontSize: 24,
                        fontWeight: FontWeight.normal))),
            Text(LocaleKeys.duringemerg.tr(),
                style: TextStyle(
                    color: Mycolors.notpressed,
                    fontSize: 24,
                    fontWeight: FontWeight.normal)),
            SizedBox(height: 40),
            RawMaterialButton(
              onPressed: () async {
                // this return an errror await withInternetConnection([ () =>
                // UserRepository().getUserById('halsdk;fj'), ]); to show how
                //   deal with an results list final results = await
                // withInternetConnection([ () => UserRepository()
                // .getUserById('mOWCpqtfbKenJvEblEXEBTgy1uP2'), () =>
                // UserRepository()
                //   .checkUserExist('mOWCpqtfbKenJvEblEXEBTgy1uP2'), ]); for
                //       (dynamic object in results) { if (object is
                //   UserProfile) { print(object.username); } else if (object is
                //       bool) { print(object); } } example on how try catch
                // block works try { await
                // UserRepository().getUserById('halsdk;fj'); } catch (e) {
                //   print('object'); // print error in flutter toast
                //     Fluttertoast.showToast( msg: e.toString(), toastLength:
                //   Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM,
                //     timeInSecForIosWeb: 1, backgroundColor: Colors.red,
                //   textColor: Colors.white, fontSize: 16.0); }

                try {
                  await RequestRepository().createRequestAndNotifyCaregivers();
                  createRideRequest();
                  availableDrivers =FireHelper.nearbyDriverList;
                  findDriver();
                  details = await acceptTrip(rideRef?.key);
                  print('Please Work');
                  print(details);
                  print(details.driverName);
                  while (details == null ){
                    await Future.delayed(Duration(milliseconds: 500));
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => showMap( driverAssignedDetails: details,)),);
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: e.toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Mycolors.buttoncolor,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              elevation: 0.0,
              highlightElevation: 15.0,
              fillColor: Color(0xFFBCDEFA),
              highlightColor: Color(0xFF9AC5F5),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
              child: Center(
                child: ClipOval(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 125,
                        backgroundColor: Color(0xFF9AC5F5),
                      ),
                      CircleAvatar(
                        radius: 110,
                        backgroundColor: Color(0xFF5695EC),
                      ),
                      CircleAvatar(
                        radius: 95,
                        backgroundColor: Color(0xFF1264E2),
                      ),
                      SvgPicture.asset("assets/images/sos icon.svg")
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            Container(
              width: double.infinity,
              height: 66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Mycolors.splashback,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => chatbotPage()));
                    },
                    child: Container(
                      margin: langCode == 'en'
                          ? EdgeInsets.all(0)
                          : EdgeInsets.only(right: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 4),
                          Stack(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 30),
                                  height: 35,
                                  width: 35,
                                  child: SvgPicture.asset(
                                      "assets/images/carbon_chat-bot.svg"))
                            ],
                          ),
                          SizedBox(height: 3),
                          Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Text(LocaleKeys.chatbot.tr(),
                                  style: langCode == 'en'
                                      ? TextStyle(
                                          color: Mycolors.notpressed,
                                          fontWeight: FontWeight.w500)
                                      : TextStyle(
                                          color: Mycolors.notpressed,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10))),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        SizedBox(height: 4),
                        Stack(
                          children: [
                            Container(
                                height: 35,
                                width: 35,
                                child: SvgPicture.asset(
                                    "assets/images/Vector (1).svg"))
                          ],
                        ),
                        SizedBox(height: 3),
                        Text(LocaleKeys.Home.tr(),
                            style: langCode == 'en'
                                ? TextStyle(
                                    color: Mycolors.textcolor,
                                    fontWeight: FontWeight.w500)
                                : TextStyle(
                                    color: Mycolors.textcolor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10)),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => MapsPage())));
                      },
                      child: Container(
                        margin: langCode == 'en'
                            ? EdgeInsets.all(0)
                            : EdgeInsets.only(left: 20),
                        child: Column(
                          children: [
                            SizedBox(height: 4),
                            Stack(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(right: 30),
                                    height: 35,
                                    width: 35,
                                    child: SvgPicture.asset(
                                        "assets/images/Vector.svg"))
                              ],
                            ),
                            SizedBox(height: 3),
                            Container(
                                margin: EdgeInsets.only(right: 30),
                                child: Text(LocaleKeys.maps.tr(),
                                    style: langCode == 'en'
                                        ? TextStyle(
                                            color: Mycolors.notpressed,
                                            fontWeight: FontWeight.w500)
                                        : TextStyle(
                                            color: Mycolors.notpressed,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10))),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
      );
    }
  }
}
