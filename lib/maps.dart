import 'dart:async';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradproject/loadingcontainer.dart';
import 'package:gradproject/trip/BrandDivider.dart';
import 'package:gradproject/trip/customizedButton.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'utils/mapSimulaitonHelperFunctions.dart';
import 'package:flutter/material.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  // gmaps.LatLng startPosition =
  //     gmaps.LatLng(31.251564761896724, 29.975737549014042);
  // gmaps.LatLng endPosition = gmaps.LatLng(31.2407, 29.9874);
  gmaps.LatLng startPosition = gmaps.LatLng(31.2980, 30.0571);
  gmaps.LatLng endPosition = gmaps.LatLng(31.3085037, 30.0635744);
  int velocity = 80; //km per hour
  gmaps.LatLng currentPosition =
      gmaps.LatLng(31.251564761896724, 29.975737549014042);
  /* -------------------------------------------------------------------------- */
  gmaps.BitmapDescriptor? _carIcon;
  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  List<gmaps.LatLng> _allPoints = [];
  Set<gmaps.Polyline> _polylines = {};
  double tripSheetHeight = 300;
  double mapBottomPadding = 300;
  late gmaps.GoogleMapController mapController;
  double currentEta = 0;
  String _eta = '';
  String _reachingTime = '';
  bool isTripCompleted = false;
  /* -------------------------------------------------------------------------- */
  @override
  void initState() {
    loadCarIcon();
    initStateAsync();
    super.initState();
  }

  void initStateAsync() async {
    List<gmaps.LatLng> directions = await getDrivingDirections(
        convertGmapsLatLngToString(startPosition),
        convertGmapsLatLngToString(endPosition));
    if (mounted) {
      setState(() {
        _allPoints = directions;
        _polylines.add(
          gmaps.Polyline(
            polylineId: gmaps.PolylineId("route"),
            color: Colors.blue,
            width: 5,
            points: directions,
          ),
        );
      });
    }
    isTripCompleted = await startAnimation(); //returns true when comp
  }

  Future<bool> startAnimation() async {
    if (_allPoints.length > 1) {
      _reachingTime = DateTime.now()
          .add(Duration(
              seconds: (calculateEta(_allPoints, velocity) * 60 * 60).round()))
          .toString()
          .substring(11, 16);
      currentEta = calculateEta(_allPoints, velocity) * 60 * 60;
      for (int i = 1; i < _allPoints.length; i++) {
        gmaps.LatLng firstPoint = _allPoints[i - 1];
        gmaps.LatLng secondPoint = _allPoints[i];
        double distance = calculateDistance(firstPoint, secondPoint);
        double time = calculateTime(distance, velocity);
        double timeInSeconds = time * 60 * 60;
        await Future.delayed(Duration(seconds: timeInSeconds.round()));
        if (mounted) {
          setState(() {
            currentEta -= timeInSeconds;
            _eta = formatTime(currentEta);
            currentPosition = secondPoint;
            mapController.animateCamera(
              gmaps.CameraUpdate.newCameraPosition(
                gmaps.CameraPosition(
                  target: currentPosition,
                  zoom: 15.0,
                ),
              ),
            );
            _polylines.add(
              gmaps.Polyline(
                polylineId: gmaps.PolylineId("route"),
                color: Colors.blue,
                width: 5,
                points: _allPoints.sublist(i, _allPoints.length),
              ),
            );
          });
        }
      }
    }
    return true;
  }

  void loadCarIcon() async {
    BitmapDescriptor icon = await gmaps.BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)),
      'assets/images/car_android.png',
    );
    setState(() {
      _carIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_carIcon == null) return loadingContainer();
    return Scaffold(
        key: scaffoldkey,
        body: Stack(
          children: <Widget>[
            gmaps.GoogleMap(
              padding: EdgeInsets.only(bottom: mapBottomPadding),
              mapType: gmaps.MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: gmaps.CameraPosition(
                target: currentPosition,
                zoom: 15.0,
              ),
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (controller) => mapController = controller,
              markers: [
                gmaps.Marker(
                  markerId: gmaps.MarkerId("car"),
                  position: currentPosition,
                  icon: _carIcon!,
                ),
              ].toSet(),
              polylines: _polylines,
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
                              _eta == ''
                                  ? 'Calculating ETA'
                                  : 'the ambulance will reach \nyou in ' +
                                      _eta +
                                      ' minutes at ' +
                                      _reachingTime,
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

                        Text(
                            isTripCompleted
                                ? 'Trip Completed'
                                : 'the ambulance is on the way from مستشفى الإقبال',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Brand-Bold')),
                        SizedBox(
                          height: 20,
                        ),

                        customizedButton(
                          title: 'GO BACK',
                          color: Colors.blue,
                          onPressed: () {
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
        ));
  }
}
