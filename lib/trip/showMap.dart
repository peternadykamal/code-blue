import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gradproject/globalvariables.dart';
import 'package:gradproject/maps.dart';
import 'package:gradproject/trip/DriverAssignedDetails.dart';
import 'package:gradproject/trip/NoDriverDialog.dart';
import 'package:gradproject/trip/appdata.dart';
import 'package:gradproject/trip/brand_colors.dart';
import 'package:gradproject/trip/firehelper.dart';
import 'package:gradproject/trip/helpermethods.dart';
import 'package:gradproject/trip/nearbydriver.dart';
import 'package:gradproject/trip/safeHandsDialog.dart';
import 'package:provider/provider.dart';
import 'BrandDivider.dart';

class showMap extends StatefulWidget {
  //static const String id= 'showMap';
  final DriverAssignedDetails driverAssignedDetails;
  // showMap(this.driverAssignedDetails);

  const showMap({Key? key, required this.driverAssignedDetails})
      : super(key: key);

  @override
  _showMapState createState() => _showMapState();

  // @override
  // State<showMap> createState() => _showMapState();
}

class _showMapState extends State<showMap> {
  late Position currentPosition;
  var geoLocator = Geolocator();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late GoogleMapController mapController;
  double mapBottomPadding = 0;
  // double searchSheetHeight= 300; // try 300
  // double requestSheetHeight= 0;
  double tripSheetHeight = 300;
  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  bool drawerCanOpen = false;
  DatabaseReference? rideRef;
  BitmapDescriptor? nearbyIcon;
  bool nearbyDriversKeysLoaded = false;
  List<NearbyDriver>? availableDrivers;
  StreamSubscription<DatabaseEvent>? rideSubscription;
  bool isRequestingLocationDetails = false;
  Position? myPosition;
  Timer? _timer;
  Set<Marker> _Markers = {};

  String? getDriverName() {
    String? dName = widget.driverAssignedDetails.driverName;
    return dName;
  }

  LatLng? getHospitalLocation() {
    LatLng? hLoc = widget.driverAssignedDetails.hospitalLocation;
    return hLoc;
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.205753, 29.924526),
    zoom: 14.4746,
  );

  void setupPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    // String address = await HelperMethods.findCordinateAddress(position, context);
    // print(address);

    startGeofireListener();
  }

  void showTripSheet() {
    setState(() {
      tripSheetHeight = 300;
      mapBottomPadding = 300;
    });

    createRideRequest();
  }

  void dispose() {
    super.dispose();

    // Cancel the timer to prevent memory leaks
    if (_timer != null) {
      _timer?.cancel();
    }
  }

  void createRideRequest() {
    rideRef = FirebaseDatabase.instance.reference().child('rideRequest').push();

    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;

    Map pickupMap = {
      'latitude': pickup.latitude.toString(),
      'longitude': pickup.longitude.toString(),
    };

    Map rideMap = {
      'created_at': DateTime.now().toString(),
      'rider_name': currentUserInfo?.username,
      'rider_phone': currentUserInfo?.phoneNumber,
      'pickup_address': pickup.placeName,
      'location': pickupMap,
      'driver_id': 'waiting',
    };

    rideRef?.set(rideMap);
    print('RideRequested Check firebase');

    rideSubscription = rideRef?.onValue.listen((event) async {
      //check for null snapshot

      dynamic rideData = event.snapshot.value;
      if (rideData == null) {
        return;
      }
      // Get Driver Name
      if (rideData['driver_name'] != null) {
        driverFullName = rideData['driver_name'].toString();
        print('Driver Name is:  ${driverFullName}');
      }
      // Get Driver Phone
      if (rideData['driver_phone'] != null) {
        driverPhone = rideData['driver_phone'].toString();
        print('Driver mobile number is:  ${driverPhone}');
      }
      // Get Driver Vehicle Details
      if (rideData['vehicle_details'] != null) {
        driverCarNumber = rideData['vehicle_details'].toString();
        print('vehicle number = ${driverCarNumber}');
      }
      //Get and Use Driver Location Updates
      if (rideData['driver_location'] != null) {
        double driverLat =
            double.parse(rideData['driver_location']['latitude'].toString());
        double driverLng =
            double.parse(rideData['driver_location']['longitude'].toString());

        print('Driver Latitude = ${driverLat}');
        print('Driver Longitude = ${driverLng}');

        LatLng driverLocation = LatLng(driverLat, driverLng);

        if (status == 'going') {}
      }

      if (rideData['status'] != null) {
        status = rideData['status'].toString();
      }

      if (status == 'accepted') {
        showTripSheet();
        Geofire.stopListener();
      }

      if (status == 'picked') {
        safeHands();
      }
    });
  }

  void cancelRequest() {
    rideRef?.remove();
  }

  void startGeofireListener() {
    Geofire.initialize('driversAvailable');

    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, 4)
        ?.listen((map) {
      print(map);
      print('AFTEEEEEEEER');
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          // case Geofire.onKeyEntered:
          //
          //   NearbyDriver nearbyDriver = NearbyDriver();
          //   nearbyDriver.key = map['key'];
          //   nearbyDriver.latitude = map['latitude'];
          //   nearbyDriver.longitude = map['longitude'];
          //   FireHelper.nearbyDriverList.add(nearbyDriver);
          //
          //   if(nearbyDriversKeysLoaded){
          //     //updateDriversOnMap();
          //     print('NearbyDriverKeys is Loaded');
          //   }
          //
          //   break;
          //
          // case Geofire.onKeyExited:
          //   FireHelper.removeFromList(map['key']);
          //   //updateDriversOnMap();
          //   break;
          //
          // case Geofire.onKeyMoved:
          // // Update your key's location
          //   NearbyDriver nearbyDriver = NearbyDriver();
          //   nearbyDriver.key = map['key'];
          //   nearbyDriver.latitude = map['latitude'];
          //   nearbyDriver.longitude = map['longitude'];
          //
          //   FireHelper.updateNearbyLocation(nearbyDriver);
          //
          //   //updateDriversOnMap();
          //   break;

          case Geofire.onGeoQueryReady:
            // All Intial Data is loaded
            //print(map['result']);

            print('Firehelper length: ${FireHelper.nearbyDriverList.length}');

            nearbyDriversKeysLoaded = true;
            updateDriversOnMap();
            break;
        }
      }

      setState(() {});
    });
  }

  void updateDriversOnMap() {
    setState(() {
      _Markers.clear();
    });

    Set<Marker> tempMarkers = Set<Marker>();

    for (NearbyDriver driver in FireHelper.nearbyDriverList) {
      double latitudeDriver =
          driver.latitude ?? 0.0; // If driver.latitude is null, set it to 0.0
      double longitudeDriver =
          driver.longitude ?? 0.0; // If driver.longitude is null, set it to 0.0
      LatLng driverPosition = LatLng(latitudeDriver, longitudeDriver);

      Marker thisMarker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverPosition,
        icon:
            nearbyIcon!, //BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
        rotation: HelperMethods.generateRandomNumber(360),
      );

      tempMarkers.add(thisMarker);
    }

    setState(() {
      _Markers = tempMarkers;
    });
  }

  void createMarker() {
    if (nearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/images/car_android.png')
          .then((icon) {
        nearbyIcon = icon;
      });
    }
  }

  restApp() {
    setState(() {
      //searchSheetHeight = 300;
      mapBottomPadding = 300;
      //requestSheetHeight=0;
      drawerCanOpen = true;
    });

    setupPositionLocator();
  }

  void safeHands() {
    print('No Drivers Available');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => safeHandsDialog(),
    );
  }

  void noDriverFound() {
    print('No Drivers Available');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => NoDriverDialog(),
    );
  }

  void findDriver() {
    if (availableDrivers?.length == 0) {
      cancelRequest();
      restApp();
      //No Driver
      noDriverFound();
      print('NO AVAILABLE DRIVERS');
      return;
    }

    var driver = availableDrivers?[0];

    //notifyDriver(driver!);

    //availableDrivers?.removeAt(0);
    print("DRIVER IS ASSIGNED222");
    print(driver?.key);
  }
  //
  // void notifyDriver(NearbyDriver driver){
  //   DatabaseReference driverTripRef = FirebaseDatabase.instance.reference().child('drivers/${driver.key}/newtrip');
  //   driverTripRef?.set(rideRef?.key);
  //
  //   //Get and notify driver using token
  //   DatabaseReference tokenRef = FirebaseDatabase.instance.reference().child('drivers/${driver.key}/token');
  //
  //   tokenRef.once().then((DatabaseEvent databaseEvent) async {
  //
  //
  //     dynamic rideData=databaseEvent.snapshot.value;
  //     if(rideData !=null){
  //
  //       String token = rideData.toString();
  //       print('Token from Database: $token');
  //
  //       //send notification to selected driver
  //       //HelperMethods.sendNotification(token, context, rideRef?.key ?? '');
  //
  //
  //
  //     }
  //
  //
  //   }).catchError((error) {
  //     // Handle errors here
  //     print('Error retrieving data: $error');
  //
  //   });
  //
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //HelperMethods.getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    createMarker();
    print('CHECK THIS!');
    print(widget.driverAssignedDetails.driverName);
    print(widget.driverAssignedDetails.hospitalLocation);
    print(widget.driverAssignedDetails.hospitalLocation?.latitude);
    print(widget.driverAssignedDetails.hospitalLocation?.longitude);
    String hospitalName = getDriverName()!;

    LatLng? cat = widget.driverAssignedDetails.hospitalLocation;
    print(cat);

    return Scaffold(
        key: scaffoldkey,
        body: Stack(
          children: <Widget>[
            GoogleMap(
              padding: EdgeInsets.only(bottom: mapBottomPadding),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              markers: _Markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;
                setState(() {
                  mapBottomPadding = 300;
                });
                setupPositionLocator();
              },
            ),
            //TripSheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                duration: new Duration(milliseconds: 150),
                curve: Curves.easeIn,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15.0, //Soften the shadow
                          spreadRadius: 0.5, //Extend the shadow
                          offset: Offset(
                            0.7, //Move to the right 10 Horizontally
                            0.7, //Move to the bottom 10 Vertically
                          ),
                        )
                      ]),
                  height: tripSheetHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),

                        //TripStatus
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tripStatusDisplay,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'Brand-Bold'),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        BrandDivider(),

                        SizedBox(
                          height: 20,
                        ),

                        Text(
                          driverCarNumber,
                          style: TextStyle(color: BrandColors.colorTextLight),
                        ),

                        Text(
                          getDriverName()!,
                          style: TextStyle(fontSize: 20),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        BrandDivider(),

                        SizedBox(
                          height: 20,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular((25))),
                                    border: Border.all(
                                        width: 1.0,
                                        color: BrandColors.colorTextLight),
                                  ),
                                  child: Icon(Icons.call),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Call'),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MapsPage()),
                                    );
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular((25))),
                                      border: Border.all(
                                          width: 1.0,
                                          color: BrandColors.colorTextLight),
                                    ),
                                    child: Icon(Icons.list),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Details'),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
