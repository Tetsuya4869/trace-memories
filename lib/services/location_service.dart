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
    ).listen(
      (geo.Position position) {
        _path = [..._path, position];
        _controller.add(List.from(_path));
      },
      onError: (Object error) {
        _controller.addError(error);
      },
      cancelOnError: false,
    );
  }

  void stopTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  void dispose() {
    stopTracking();
    _controller.close();
  }

  void clearPath() {
    _path = [];
    _controller.add([]);
  }
}
