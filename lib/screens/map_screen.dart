import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../theme/app_theme.dart';
import '../widgets/photo_card.dart';
import '../widgets/timeline_bar.dart';
import '../widgets/glass_container.dart';
import '../widgets/summary_dialog.dart';
import '../services/location_service.dart';
import '../services/photo_service.dart';
import '../services/summary_service.dart';
import '../services/map_route_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const double _offScreenMargin = 100;
  static const double _cardOffsetX = 60;
  static const double _cardOffsetY = 160;

  final LocationService _locationService = LocationService();
  final PhotoService _photoService = PhotoService();
  final SummaryService _summaryService = SummaryService();
  final MapRouteController _mapController = MapRouteController();
  StreamSubscription<List<geo.Position>>? _pathSubscription;

  double _timelineProgress = 1.0;
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
      _pathSubscription = _locationService.pathStream.listen((path) {
        if (mounted) {
          setState(() => _currentPath = path);
          _mapController.updateRouteLayer(_currentPath, _timelineProgress);
        }
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('位置情報の権限が必要です。設定から許可してください。'),
          duration: Duration(seconds: 4),
        ),
      );
    }

    final hasPhotoPermission = await _photoService.requestPermission();
    if (hasPhotoPermission) {
      await _loadPhotos();
      _autoZoomToFirstMemory();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('写真ライブラリへのアクセスを許可すると、思い出を地図に表示できます。'),
          duration: Duration(seconds: 4),
        ),
      );
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

  void _autoZoomToFirstMemory() {
    if (_photoMemories.isNotEmpty) {
      _mapController.zoomToMemory(_photoMemories.last);
    }
  }

  @override
  void dispose() {
    _pathSubscription?.cancel();
    _locationService.dispose();
    super.dispose();
  }

  void _showSummary() {
    final summary = _summaryService.generateSummary(
      path: _currentPath,
      photos: _photoMemories,
    );
    showDialog(
      context: context,
      builder: (context) => SummaryDialog(summary: summary),
    );
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
            onMapCreated: _mapController.onMapCreated,
            onCameraChangeListener: (_) => setState(() {}),
          ),

          ..._buildPhotoCards(),

          _buildAppTitle(),
          _buildTimelineBar(),
          _buildStatusIndicator(),
          _buildSummaryButton(),

          if (_isLoadingPhotos)
            const Center(child: CircularProgressIndicator(color: AppTheme.accentBlue)),
        ],
      ),
    );
  }

  List<Widget> _buildPhotoCards() {
    final filtered = _photoMemories.where((m) {
      if (_photoMemories.isEmpty) return false;
      final idx = _photoMemories.indexOf(m);
      return (idx / _photoMemories.length) <= _timelineProgress;
    }).toList();

    return filtered.map((photo) {
      return FutureBuilder<ScreenCoordinate?>(
        future: _mapController.pixelForMemory(photo),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) return const SizedBox.shrink();
          final pos = snapshot.data!;
          if (pos.x < -_offScreenMargin || pos.x > MediaQuery.of(context).size.width + _offScreenMargin ||
              pos.y < -_offScreenMargin || pos.y > MediaQuery.of(context).size.height + _offScreenMargin) {
            return const SizedBox.shrink();
          }

          return Positioned(
            left: pos.x - _cardOffsetX,
            top: pos.y - _cardOffsetY,
            child: PhotoCard(
              imageBytes: photo.thumbnail,
              emoji: '📸',
              time: '${photo.dateTime.hour}:${photo.dateTime.minute.toString().padLeft(2, '0')}',
              location: 'この場所で',
              onTap: () => _mapController.flyToMemory(photo),
            ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).fadeIn(),
          );
        },
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
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1.5),
              children: [
                TextSpan(text: 'Trace'),
                TextSpan(text: 'Memories', style: TextStyle(color: AppTheme.accentBlue)),
              ],
            ),
          ),
          const Text('あなたの日々を、地図に刻む', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 1.5)),
        ],
      ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
    );
  }

  Widget _buildTimelineBar() {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 30,
      left: 20, right: 20,
      child: TimelineBar(
        selectedDate: DateTime.now(),
        progress: _timelineProgress,
        isLive: _timelineProgress > 0.95,
        onProgressChanged: (value) {
          setState(() => _timelineProgress = value);
          _mapController.updateRouteLayer(_currentPath, _timelineProgress);
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
              '${_photoMemories.length} の思い出',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _buildSummaryButton() {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 120,
      right: 20,
      child: FloatingActionButton(
        onPressed: _showSummary,
        backgroundColor: AppTheme.accentBlue,
        child: const Icon(Icons.history_edu, color: AppTheme.primaryDark),
      ).animate().scale(delay: 1000.ms),
    );
  }
}
