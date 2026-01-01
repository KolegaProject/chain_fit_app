import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  /// Request location permission
  Future<bool> requestPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  /// Check if location service is enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Get current position
  Future<Position?> getCurrentPosition() async {
    // Check permission first
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null; // Permission denied
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null; // Permissions are denied forever
    }

    // Determine position
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null; // Failed to get location
    }
  }
}
