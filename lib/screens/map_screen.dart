import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../theme/app_theme.dart';
import '../widgets/photo_card.dart';
import '../widgets/timeline_bar.dart';
import '../services/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMap? _mapboxMap;
  final LocationService _locationService = LocationService();
  double _timelineProgress = 0.3;
  List<geo.Position> _currentPath = [];
  
  // Sample data for demo
  final List<Map<String, dynamic>> _samplePhotos = [
    {'emoji': '🏔️', 'time': '10:30 AM', 'location': 'Mt. Fuji Area', 'top': 0.25, 'left': 0.1},
    {'emoji': '🍜', 'time': '01:15 PM', 'location': 'Kawaguchiko', 'top': 0.4, 'left': 0.4},
    {'emoji': '🌸', 'time': '04:00 PM', 'location': 'Park Center', 'top': 0.2, 'left': 0.7},
  ];

  @override
  void initState() {
    super.initState();
    _initTracking();
  }

  Future<void> _initTracking() async {
    final hasPermission = await _locationService.handlePermission();
    if (hasPermission) {
      _locationService.startTracking();
      _locationService.pathStream.listen((path) {
        setState(() {
          _currentPath = path;
        });
        _updateMapPath();
      });
    }
  }

  void _updateMapPath() {
    if (_mapboxMap == null || _currentPath.isEmpty) return;
    
    // In Mapbox Maps Flutter v2, we use PolylineAnnotationManager or GeoJsonSource
    // For simplicity in this step, let's focus on the UI and assume the path logic is evolving
  }

  _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    // Initial camera position
    _mapboxMap?.setCamera(CameraOptions(
      center: Point(coordinates: Position(138.7278, 35.3606)).toJson(),
      zoom: 12.0,
      pitch: 45.0, // Slight tilt for 3D feel
    ));
  }

  @override
  Widget build(BuildContext context) {
    MapboxOptions.setAccessToken(dotenv.env['MAPBOX_PUBLIC_TOKEN'] ?? "");

    return Scaffold(
      body: Stack(
        children: [
          // Actual Mapbox View
          MapWidget(
            key: const ValueKey("mapWidget"),
            styleUri: MapboxStyles.DARK,
            onMapCreated: _onMapCreated,
          ),
          
          // Floating overlay for depth
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryDark.withOpacity(0.4),
                    Colors.transparent,
                    AppTheme.primaryDark.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),
          
          // Photo cards
          ..._buildPhotoCards(),
          
          // App title
          _buildAppTitle(),
          
          // Timeline bar
          _buildTimelineBar(),
          
          // Tracking Status Indicator
          _buildStatusIndicator(),
        ],
      ),
    );
  }
  
  Widget _buildStatusIndicator() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: AppTheme.glassDecoration,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
              ),
            ).animate(onPlay: (controller) => controller.repeat())
             .fadeIn(duration: 500.ms).fadeOut(delay: 500.ms),
            const SizedBox(width: 8),
            const Text(
              'Tracking On',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPhotoCards() {
    return _samplePhotos.asMap().entries.map((entry) {
      final index = entry.key;
      final photo = entry.value;
      return Positioned(
        top: MediaQuery.of(context).size.height * (photo['top'] as double),
        left: MediaQuery.of(context).size.width * (photo['left'] as double),
        child: PhotoCard(
          emoji: photo['emoji'] as String,
          time: photo['time'] as String,
          location: photo['location'] as String,
          onTap: () {
            // Zoom to location
          },
        ).animate(delay: Duration(milliseconds: 100 * index)),
      );
    }).toList();
  }
  
  Widget _buildAppTitle() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 20,
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
            color: Colors.white,
          ),
          children: [
            TextSpan(text: 'Trace'),
            TextSpan(
              text: 'Memories',
              style: TextStyle(color: AppTheme.accentBlue),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.5, end: 0),
    );
  }
  
  Widget _buildTimelineBar() {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 40,
      left: 20,
      right: 20,
      child: TimelineBar(
        selectedDate: DateTime.now(),
        progress: _timelineProgress,
        isLive: true,
        onProgressChanged: (value) {
          setState(() {
            _timelineProgress = value;
          });
        },
      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.5, end: 0),
    );
  }
}
