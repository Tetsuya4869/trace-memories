import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../theme/app_theme.dart';
import '../widgets/photo_card.dart';
import '../widgets/timeline_bar.dart';
import '../services/location_service.dart';
import '../services/photo_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMap? _mapboxMap;
  final LocationService _locationService = LocationService();
  final PhotoService _photoService = PhotoService();
  
  double _timelineProgress = 0.3;
  List<geo.Position> _currentPath = [];
  List<PhotoMemory> _photoMemories = [];
  bool _isLoadingPhotos = false;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    // Permission for location
    final hasLocPermission = await _locationService.handlePermission();
    if (hasLocPermission) {
      _locationService.startTracking();
      _locationService.pathStream.listen((path) {
        if (mounted) {
          setState(() {
            _currentPath = path;
          });
        }
      });
    }

    // Permission and fetching for photos
    final hasPhotoPermission = await _photoService.requestPermission();
    if (hasPhotoPermission) {
      _loadPhotos();
    }
  }

  Future<void> _loadPhotos() async {
    setState(() => _isLoadingPhotos = true);
    final memories = await _photoService.getMemoriesForDate(DateTime.now());
    if (mounted) {
      setState(() {
        _photoMemories = memories;
        _isLoadingPhotos = false;
      });
    }
  }

  _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _mapboxMap?.setCamera(CameraOptions(
      center: Point(coordinates: Position(139.7671, 35.6812)).toJson(), // Default to Tokyo
      zoom: 12.0,
      pitch: 45.0,
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
          
          // Photo cards (Real data)
          ..._buildPhotoCards(),
          
          // App title
          _buildAppTitle(),
          
          // Timeline bar
          _buildTimelineBar(),
          
          // Status Indicator
          _buildStatusIndicator(),
          
          if (_isLoadingPhotos)
            const Center(child: CircularProgressIndicator(color: AppTheme.accentBlue)),
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
            Text(
              '${_photoMemories.length} Memories',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPhotoCards() {
    // In a real app, we would convert lat/lng to screen coordinates
    // For now, we use a simple algorithm or let Mapbox handle markers
    // To maintain the "floating card" look from the mockup:
    return _photoMemories.asMap().entries.map((entry) {
      final index = entry.key;
      final photo = entry.value;
      
      // Temporary: scatter them for visual effect until projection is implemented
      return Positioned(
        top: 100.0 + (index * 150.0 % 400.0),
        left: 50.0 + (index * 100.0 % 250.0),
        child: PhotoCard(
          imageBytes: photo.thumbnail,
          emoji: '📸',
          time: '${photo.dateTime.hour}:${photo.dateTime.minute.toString().padLeft(2, '0')}',
          location: 'Memory ${index + 1}',
          onTap: () {
            _mapboxMap?.setCamera(CameraOptions(
              center: Point(coordinates: Position(photo.longitude!, photo.latitude!)).toJson(),
              zoom: 15.0,
            ));
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
