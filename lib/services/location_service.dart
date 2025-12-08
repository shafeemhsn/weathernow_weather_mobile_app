import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentCoordinates() async {
    final hasPermission = await _ensurePermissionGranted();
    if (!hasPermission) {
      throw Exception('Location permission denied');
    }

    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<bool> _ensurePermissionGranted() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }
}
