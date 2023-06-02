import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

Future<List<gmaps.LatLng>> getDrivingDirections(
    String source, String destination) async {
  String mapboxToken = dotenv.env['MAPBOX_TOKEN']!;

  final String url =
      "https://api.mapbox.com/directions/v5/mapbox/driving/$source;$destination?geometries=geojson&access_token=$mapboxToken";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final coordinates = decodedData['routes'][0]['geometry']['coordinates'];
      final List<latlong.LatLng> routeCoordinates = [];

      for (final coordinate in coordinates) {
        final double latitude = coordinate[1];
        final double longitude = coordinate[0];
        routeCoordinates.add(latlong.LatLng(latitude, longitude));
      }

      return convertLatLngList(routeCoordinates);
    } else {
      throw Exception(
          'Failed to get driving directions: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Failed to get driving directions: $error');
  }
}

// convert from LatLng to gmaps.LatLng
gmaps.LatLng convertLatLng(latlong.LatLng latLng) {
  return gmaps.LatLng(latLng.latitude, latLng.longitude);
}

// convert from List<LatLng> to List<gmaps.LatLng>
List<gmaps.LatLng> convertLatLngList(List<latlong.LatLng> latLngList) {
  final List<gmaps.LatLng> gmapsLatLngList = [];
  for (final latLng in latLngList) {
    gmapsLatLngList.add(convertLatLng(latLng));
  }
  return gmapsLatLngList;
}

// convert from gmaps.LatLng to string
String convertGmapsLatLngToString(gmaps.LatLng latLng) {
  return '${latLng.longitude},${latLng.latitude}';
}

double calculateDistance(gmaps.LatLng firstPoint, gmaps.LatLng secondPoint) {
  const int earthRadius = 6371; // in km
  double lat1 = firstPoint.latitude;
  double lon1 = firstPoint.longitude;
  double lat2 = secondPoint.latitude;
  double lon2 = secondPoint.longitude;
  double dLat = _toRadians(lat2 - lat1);
  double dLon = _toRadians(lon2 - lon1);
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadius * c;
  return distance;
}

double _toRadians(double degree) {
  return degree * pi / 180;
}

double calculateTime(double distance, int velocity) {
  return distance / velocity;
}

double calculateEta(List<gmaps.LatLng> points, int velocity) {
  double distance = 0;
  for (int i = 1; i < points.length; i++) {
    distance += calculateDistance(points[i - 1], points[i]);
  }
  double time = calculateTime(distance, velocity);
  return time;
}

String formatTime(double seconds) {
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds.toInt() % 60;
  return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
}
