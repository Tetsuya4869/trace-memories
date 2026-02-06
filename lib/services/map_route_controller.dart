import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../theme/app_theme.dart';
import '../models/photo_memory.dart';

class MapRouteController {
  static const double _routeLineWidth = 6.0;
  static const double _overviewZoom = 15.0;
  static const double _focusZoom = 17.0;
  static const double _cameraPitch = 60.0;
  static const int _flyToDurationMs = 1000;

  MapboxMap? _mapboxMap;
  PolylineAnnotationManager? _polylineManager;

  MapboxMap? get mapboxMap => _mapboxMap;

  void onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
  }

  Future<void> updateRouteLayer(List<geo.Position> path, double progress) async {
    if (_mapboxMap == null || path.isEmpty) return;
    _polylineManager ??= await _mapboxMap?.annotations.createPolylineAnnotationManager();

    final visibleCount = (path.length * progress).toInt();
    if (visibleCount < 2) {
      _polylineManager?.deleteAll();
      return;
    }

    final coords = path.take(visibleCount).map((p) => Position(p.longitude, p.latitude)).toList();
    _polylineManager?.deleteAll();
    _polylineManager?.create(PolylineAnnotationOptions(
      geometry: LineString(coordinates: coords),
      lineColor: AppTheme.accentBlue.value,
      lineWidth: _routeLineWidth,
    ));
  }

  void zoomToMemory(PhotoMemory memory) {
    if (_mapboxMap == null) return;
    _mapboxMap?.setCamera(CameraOptions(
      center: Point(coordinates: Position(memory.longitude!, memory.latitude!)),
      zoom: _overviewZoom,
      pitch: _cameraPitch,
    ));
  }

  void flyToMemory(PhotoMemory memory) {
    _mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(memory.longitude!, memory.latitude!)),
        zoom: _focusZoom,
        pitch: _cameraPitch,
      ),
      MapAnimationOptions(duration: _flyToDurationMs),
    );
  }

  Future<ScreenCoordinate?> pixelForMemory(PhotoMemory memory) {
    return _mapboxMap?.pixelForCoordinate(
      Point(coordinates: Position(memory.longitude!, memory.latitude!)),
    ) ?? Future.value(null);
  }
}
