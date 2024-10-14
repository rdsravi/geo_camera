// lib/attendance/location_helper.dart
import 'package:geolocator/geolocator.dart';

Future<String> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return 'Location services are disabled.';
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      return 'Location permissions are permanently denied.';
    }
    if (permission == LocationPermission.denied) {
      return 'Location permissions are denied.';
    }
  }

  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return 'Lat: ${position.latitude}, Long: ${position.longitude}';
}
