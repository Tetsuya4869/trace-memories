import 'dart:ui';
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
  VoidCallback? _onMapReady;

  bool get isMapReady => _mapboxMap != null;

  void onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _onMapReady?.call();
    _onMapReady = null;
  }

  void whenReady(VoidCallback callback) {
    if (isMapReady) {
      callback();
    } else {
      _onMapReady = callback;
    }
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
    final lat = memory.latitude;
    final lng = memory.longitude;
    if (_mapboxMap == null || lat == null || lng == null) return;
    _mapboxMap?.setCamera(CameraOptions(
      center: Point(coordinates: Position(lng, lat)),
      zoom: _overviewZoom,
      pitch: _cameraPitch,
    ));
  }

  void flyToMemory(PhotoMemory memory) {
    final lat = memory.latitude;
    final lng = memory.longitude;
    if (_mapboxMap == null || lat == null || lng == null) return;
    _mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(lng, lat)),
        zoom: _focusZoom,
        pitch: _cameraPitch,
      ),
      MapAnimationOptions(duration: _flyToDurationMs),
    );
  }

  Future<ScreenCoordinate?> pixelForMemory(PhotoMemory memory) {
    final lat = memory.latitude;
    final lng = memory.longitude;
    if (_mapboxMap == null || lat == null || lng == null) {
      return Future.value(null);
    }
    return _mapboxMap!.pixelForCoordinate(
      Point(coordinates: Position(lng, lat)),
    );
  }
}
