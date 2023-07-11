import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradproject/trip/customizedButton.dart';

class newMap extends StatefulWidget {





  @override
  _newMapState createState() => _newMapState();

}

class _newMapState extends State<newMap> {
  late Position currentPosition;
  var geoLocator = Geolocator();
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  late GoogleMapController mapController;
  double mapBottomPadding = 0;
  double tripSheetHeight = 190;
  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  Position? myPosition;
  Timer? _timer;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.205753, 29.924526),
    zoom: 15,
  );

  void setupPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 18);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));



  }

  void showTripSheet(){
    setState(() {

      tripSheetHeight = 190;
      mapBottomPadding =300;
    });


  }

  void dispose() {
    super.dispose();

    // Cancel the timer to prevent memory leaks
    if (_timer != null) {
      _timer?.cancel();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //HelperMethods.getCurrentUserInfo();

  }

  @override
  Widget build(BuildContext context) {


    return  Scaffold(
        key: scaffoldkey,
        body: Stack(
          children: <Widget> [
            GoogleMap(
              padding: EdgeInsets.only(bottom: mapBottomPadding),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller){
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
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
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
                      ]
                  ),
                  height: tripSheetHeight,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[


                        SizedBox(height: 50,),

                        //TripStatus


                        customizedButton(
                          title: 'GO BACK',
                          color: Colors.blue,
                          onPressed: (){

                            Navigator.pop(context);



                          },
                        )



                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],

        )
    );
  }



}
