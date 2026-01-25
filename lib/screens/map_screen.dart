import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../theme/app_theme.dart';
import '../widgets/photo_card.dart';
import '../widgets/timeline_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMap? _mapboxMap;
  double _timelineProgress = 0.3;
  
  // Sample data for demo
  final List<Map<String, dynamic>> _samplePhotos = [
    {'emoji': '🏔️', 'time': '10:30 AM', 'location': 'Mt. Fuji Area', 'top': 0.25, 'left': 0.1},
    {'emoji': '🍜', 'time': '01:15 PM', 'location': 'Kawaguchiko', 'top': 0.4, 'left': 0.4},
    {'emoji': '🌸', 'time': '04:00 PM', 'location': 'Park Center', 'top': 0.2, 'left': 0.7},
  ];

  _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
  }

  @override
  Widget build(BuildContext context) {
    // Set Mapbox access token
    MapboxOptions.setAccessToken(dotenv.env['MAPBOX_PUBLIC_TOKEN'] ?? "");

    return Scaffold(
      body: Stack(
        children: [
          // Actual Mapbox View
          MapWidget(
            key: const ValueKey("mapWidget"),
            styleUri: MapboxStyles.DARK, // Use built-in Dark style for glassmorphism
            onMapCreated: _onMapCreated,
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(138.7278, 35.3606)).toJson(), // Near Mt. Fuji
              zoom: 10.0,
            ),
          ),
          
          // Floating overlay (Glassmorphism look)
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryDark.withOpacity(0.3),
                    Colors.transparent,
                    AppTheme.primaryDark.withOpacity(0.5),
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
        ],
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
            // TODO: Zoom map to this location
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
