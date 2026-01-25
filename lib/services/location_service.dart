import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class LocationService {
  StreamSubscription<Position>? _positionStreamSubscription;
  final _controller = StreamController<List<Position>>.broadcast();
  
  List<Position> _path = [];
  
  Stream<List<Position>> get pathStream => _controller.stream;
  List<Position> get currentPath => _path;

  Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    
    if (permission == LocationPermission.deniedForever) return false;
    
    return true;
  }

  void startTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // 10 meters
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _path.add(position);
      _controller.add(List.from(_path));
    });
  }

  void stopTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }
  
  void clearPath() {
    _path = [];
    _controller.add([]);
  }
  
  List<Position> getMockPath() {
    return [
      Position(longitude: 138.7278, latitude: 35.3606, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0),
      Position(longitude: 138.7350, latitude: 35.3700, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0),
      Position(longitude: 138.7450, latitude: 35.3650, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0),
    ];
  }
}
