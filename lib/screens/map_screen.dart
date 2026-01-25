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
  PolylineAnnotationManager? _polylineManager;
  final LocationService _locationService = LocationService();
  final PhotoService _photoService = PhotoService();
  
  double _timelineProgress = 0.5;
  List<geo.Position> _currentPath = [];
  List<PhotoMemory> _photoMemories = [];
  bool _isLoadingPhotos = false;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final hasLocPermission = await _locationService.handlePermission();
    if (hasLocPermission) {
      _locationService.startTracking();
      _locationService.pathStream.listen((path) {
        if (mounted) {
          setState(() {
            _currentPath = path;
          });
          _updateRouteLayer();
        }
      });
    }

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

  Future<void> _updateRouteLayer() async {
    if (_mapboxMap == null || _currentPath.isEmpty) return;

    if (_polylineManager == null) {
      _polylineManager = await _mapboxMap?.annotations.createPolylineAnnotationManager();
    }

    // Filter path based on timeline progress
    final visiblePointCount = (_currentPath.length * _timelineProgress).toInt();
    if (visiblePointCount < 2) {
      _polylineManager?.deleteAll();
      return;
    }

    final visiblePath = _currentPath.take(visiblePointCount).map((p) => 
      [p.longitude, p.latitude]
    ).toList();

    _polylineManager?.deleteAll();
    _polylineManager?.create(PolylineAnnotationOptions(
      geometry: LineString(coordinates: visiblePath).toJson(),
      lineColor: AppTheme.accentBlue.value,
      lineWidth: 5.0,
      lineCap: LineCap.ROUND,
      lineJoin: LineJoin.ROUND,
    ));
  }

  _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    
    // Set 3D terrain and buildings
    _mapboxMap?.setCamera(CameraOptions(
      center: Point(coordinates: Position(139.7671, 35.6812)).toJson(),
      zoom: 14.0,
      pitch: 60.0,
      bearing: -20.0,
    ));

    // Wait for style to load then enable 3D buildings
    _mapboxMap?.style.styleLayerExists("3d-buildings").then((exists) {
      if (!exists) {
        _mapboxMap?.style.addLayer(FillExtrusionLayer(
          id: "3d-buildings",
          sourceId: "composite",
          sourceLayer: "building",
          minZoom: 15.0,
          filter: ["==", "extrude", "true"],
          fillExtrusionColor: Colors.grey.shade900.value,
          fillExtrusionHeight: ["get", "height"],
          fillExtrusionBase: ["get", "min_height"],
          fillExtrusionOpacity: 0.8,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MapboxOptions.setAccessToken(dotenv.env['MAPBOX_PUBLIC_TOKEN'] ?? "");

    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey("mapWidget"),
            styleUri: MapboxStyles.DARK,
            onMapCreated: _onMapCreated,
          ),
          
          // Gradient Overlay
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryDark.withOpacity(0.6),
                    Colors.transparent,
                    AppTheme.primaryDark.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          
          // Photo cards (Filtered by time)
          ..._buildFilteredPhotoCards(),
          
          _buildAppTitle(),
          _buildTimelineBar(),
          _buildStatusIndicator(),
          
          if (_isLoadingPhotos)
            const Center(child: CircularProgressIndicator(color: AppTheme.accentBlue)),
        ],
      ),
    );
  }
  
  List<Widget> _buildFilteredPhotoCards() {
    // Only show photos taken before current timeline progress
    final filtered = _photoMemories.where((m) {
      if (_photoMemories.isEmpty) return false;
      final index = _photoMemories.indexOf(m);
      return (index / _photoMemories.length) <= _timelineProgress;
    }).toList();

    return filtered.asMap().entries.map((entry) {
      final index = entry.key;
      final photo = entry.value;
      
      return Positioned(
        top: 150.0 + (index * 120.0 % 300.0),
        left: 30.0 + (index * 80.0 % 200.0),
        child: PhotoCard(
          imageBytes: photo.thumbnail,
          emoji: '📸',
          time: '${photo.dateTime.hour}:${photo.dateTime.minute.toString().padLeft(2, '0')}',
          location: 'Memory ${index + 1}',
          onTap: () {
            _mapboxMap?.setCamera(CameraOptions(
              center: Point(coordinates: Position(photo.longitude!, photo.latitude!)).toJson(),
              zoom: 16.0,
            ));
          },
        ).animate().fadeIn(duration: 400.ms).scale(delay: 100.ms),
      );
    }).toList();
  }
  
  Widget _buildAppTitle() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5,
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
          ),
          const Text(
            'Your life, visualized.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
    );
  }
  
  Widget _buildTimelineBar() {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 30,
      left: 20,
      right: 20,
      child: TimelineBar(
        selectedDate: DateTime.now(),
        progress: _timelineProgress,
        isLive: _timelineProgress > 0.9,
        onProgressChanged: (value) {
          setState(() {
            _timelineProgress = value;
          });
          _updateRouteLayer();
        },
      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.5, end: 0),
    );
  }

  Widget _buildStatusIndicator() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 25,
      right: 20,
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        borderRadius: BorderRadius.circular(30),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, size: 14, color: AppTheme.accentBlue),
            const SizedBox(width: 6),
            Text(
              '${_photoMemories.length} memories found',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 800.ms);
  }
}
