import 'package:geolocator/geolocator.dart';

/// how to use this function
/// ``` dart
/// await getCurrentPosition()
/// ```
Future<Position?> getCurrentPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  // Request permission to access location
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return null;
  } else if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return null;
    }
  }

  // Get current position
  return await Geolocator.getCurrentPosition();
}
