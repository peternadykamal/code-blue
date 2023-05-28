import 'dart:async';
import 'dart:math' show atan2, pi;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:geolocator/geolocator.dart';
import 'package:gradproject/trip/safeHandsDialog.dart';
import 'package:latlong2/latlong.dart';


import 'BrandDivider.dart';
import 'LatLngTween.dart';
import 'customizedButton.dart';




class CarWidget extends StatefulWidget {
  @override
  _CarWidgetState createState() => _CarWidgetState();
}

class _CarWidgetState extends State<CarWidget> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<gmaps.LatLng>? _animation;
  gmaps.LatLng startPosition =gmaps.LatLng(31.2360983, 29.9498319);
  gmaps.LatLng endPosition =  gmaps.LatLng(31.232807, 29.9590441);
  int _duration = 12000; // duration of animation in milliseconds '10000'
  gmaps.BitmapDescriptor? _carIcon; // icon to represent the car on the map
  List<gmaps.LatLng> _intermediatePoints = [];
  Set<gmaps.Polyline> _polylines = {}; // set of polylines to draw on the map
  double tripSheetHeight = 300;
  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  double mapBottomPadding = 300;
  final Completer<gmaps.GoogleMapController> _controller2 = Completer<gmaps.GoogleMapController>();
  late gmaps.GoogleMapController mapController;
  String eta = '';
  String etaInSeconds='';
  late Timer _timer;




  // String getEtaString() {
  //   Duration duration = calculateETA(startPosition!, endPosition!);
  //   int minutes = duration.inMinutes;
  //   if (minutes == 0) {
  //     return "Less than a minute";
  //   } else if (minutes == 1) {
  //     return "1 minute";
  //   } else {
  //     return "$minutes minutes";
  //   }
  // }
  //
  // Duration calculateETA(LatLng start, LatLng end) {
  //   return Duration(
  //       seconds: (Geolocator.distanceBetween(
  //           start.latitude, start.longitude, end.latitude, end.longitude) ~/
  //           25) // assume speed of 25 meters/second
  //           .round());
  // }




  @override
  void initState()  {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: _duration),
      vsync: this,
    );
    startPosition = gmaps.LatLng(31.2344113, 29.962754); // starting location of car
    endPosition = gmaps.LatLng(31.232807, 29.9590441); // ending location of car

    // create a polyline between the start and end positions
    _polylines.add(
      gmaps.Polyline(
        polylineId: gmaps.PolylineId("route"),
        color: Colors.blue,
        width: 5,
        points: [startPosition, endPosition],
      ),
    );

    final int steps = 100; // number of interpolation steps: step = duration / interval (Before 100 )
    // For example, if your interval is 20 milliseconds, and you want a duration of 72000 milliseconds, then the number of steps should be step = 72000 / 20 = 3600.
    for (int i = 1; i <= steps; i++) {
      double t = i / steps;
      double lat = startPosition.latitude +
          (endPosition.latitude - startPosition.latitude) * t;
      double lng = startPosition.longitude +
          (endPosition.longitude - startPosition.longitude) * t;
      gmaps.LatLng point = gmaps.LatLng(lat, lng);
      _intermediatePoints.add(point);
    }

    _animation = LatLngTween(begin: startPosition, end: endPosition).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
    )
      ..addListener(() {
        setState(() {
          // Update the start position to the current position of the car

          final _animation = this._animation;
          if (_animation != null){
            startPosition = _animation.value;
          }


          // Calculate the remaining distance to the destination
          final Distance distance = Distance();
          final double remainingDistance = distance(
            LatLng(startPosition.latitude, startPosition.longitude),
            LatLng(endPosition.latitude, endPosition.longitude),
          );

          // Calculate the remaining time based on the current speed of the car
          final double speedInMps = 15.0;
          final double remainingTimeInSeconds =
          (remainingDistance / speedInMps).round().toDouble();
          final Duration remainingTime =
          Duration(seconds: remainingTimeInSeconds.toInt());

          // Update the ETA
          eta = 'ETA: ${remainingTime.inMinutes} minutes';
          etaInSeconds ='ETA: ${remainingTime} Seconds ';

        });
      });


    _controller?.forward();

    _startTimer();

    // load the car icon from an asset file
    // ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2, 2)); other code
    gmaps.BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(2, 2)),
      'assets/images/car_android.png',
    )?.then((icon) => _carIcon = icon);



  }

  @override
  void dispose() {
    _cancelTimer();
    _controller?.dispose();
    super.dispose();
  }


  void safeHands(){
    print('No Drivers Available');
    showDialog(context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => safeHandsDialog(),
    );
  }


  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      // update the start position to be the last intermediate point
      startPosition = _intermediatePoints.last;

      // remove the last intermediate point from the list
      _intermediatePoints.removeLast();

      // update the polyline to remove the last segment
      _polylines = Set<gmaps.Polyline>.from([
        gmaps.Polyline(
          polylineId: gmaps.PolylineId("route"),
          color: Colors.blue,
          width: 5,
          points: [startPosition, endPosition],
        ),
      ]);

      // calculate the new ETA
      _calculateETA(startPosition, endPosition);
    });
  }



  void _cancelTimer() {
    _timer.cancel();
  }

  void _calculateETA( gmaps.LatLng startPosition, gmaps.LatLng endPosition) {
    final Distance distance = Distance();
    final double totalDistance = distance(
      LatLng(startPosition.latitude, startPosition.longitude),
      LatLng(endPosition.latitude, endPosition.longitude),
    );
    final double speedInMps = 15.0;
    final double durationInSeconds =
    (totalDistance / speedInMps).round().toDouble();
    final Duration duration = Duration(seconds: durationInSeconds.toInt());

    setState(() {
      eta = 'ETA: ${duration.inMinutes} minutes';
      print('ETA: ${duration.inMinutes} minutes');
      etaInSeconds ='ETA: ${duration} Seconds ';
      print('ETA: ${duration} Seconds ');
      print('Total Distance: ${totalDistance}');
    });
  }







  double _getRotation() {
    // get the coordinates of the start and end points of the polyline
    gmaps.LatLng start = _intermediatePoints.first;
    gmaps.LatLng end = _intermediatePoints.last;

    // calculate the rotation angle based on the direction of the polyline
    double dx = end.longitude - start.longitude;
    double dy = end.latitude - start.latitude;
    double angle = atan2(dy, dx) * 180 / pi;

    // adjust the angle to ensure that it is always between 0 and 360 degrees
    if (angle < 0) {
      angle += 360;
    }

    return angle;
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        key: scaffoldkey,
        body: Stack(
          children: <Widget> [
            gmaps.GoogleMap(
              padding: EdgeInsets.only(bottom: mapBottomPadding),
              mapType: gmaps.MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: gmaps.CameraPosition(
                target: startPosition,
                zoom: 15.0,
              ),
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              markers: [
                gmaps.Marker(
                  markerId: gmaps.MarkerId("car"),
                  position: _animation!.value ?? gmaps.LatLng(0,0) ,
                  icon: _carIcon! ,
                  rotation: _getRotation(),
                ),
              ].toSet(),
              polylines: _polylines,
              // onMapCreated: (gmaps.GoogleMapController controller2){
              //   _controller2.complete(controller2);
              //   mapController = controller2;
              //   setState(() {
              //     mapBottomPadding = 300;
              //   });
              //
              // },
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


                        SizedBox(height: 5,),

                        //TripStatus
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(eta,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20, fontFamily: 'Brand-Bold'),
                            ),
                          ],
                        ),

                        SizedBox(height: 20,),

                        BrandDivider(),
                        SizedBox(height: 20,),
                        Text(etaInSeconds, style: TextStyle(fontSize: 20)),

                        SizedBox(height:20,),

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
