import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> current() async {
    await Geolocator.requestPermission();
    return Geolocator.getCurrentPosition();
  }
}
