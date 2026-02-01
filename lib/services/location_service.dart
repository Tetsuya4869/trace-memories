import 'dart:async';
import 'package:geolocator/geolocator.dart' as geo;

class LocationService {
  StreamSubscription<geo.Position>? _positionStreamSubscription;
  final _controller = StreamController<List<geo.Position>>.broadcast();
  
  List<geo.Position> _path = [];
  
  Stream<List<geo.Position>> get pathStream => _controller.stream;
  List<geo.Position> get currentPath => _path;

  Future<bool> handlePermission() async {
    bool serviceEnabled;
    geo.LocationPermission permission;

    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) return false;
    }
    
    if (permission == geo.LocationPermission.deniedForever) return false;
    
    return true;
  }

  void startTracking() {
    const geo.LocationSettings locationSettings = geo.LocationSettings(
      accuracy: geo.LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription = geo.Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((geo.Position position) {
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
  
  List<geo.Position> getMockPath() {
    return [
      geo.Position(longitude: 138.7278, latitude: 35.3606, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0),
      geo.Position(longitude: 138.7350, latitude: 35.3700, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0),
      geo.Position(longitude: 138.7450, latitude: 35.3650, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0),
    ];
  }
}
