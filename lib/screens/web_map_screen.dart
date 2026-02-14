import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:geolocator/geolocator.dart' as geo;
import 'settings_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/timeline_bar.dart';
import '../widgets/summary_dialog.dart';
import '../services/demo_data.dart';
import '../services/summary_service.dart';

/// Web版マップ画面（デモモード）
/// flutter_map + OpenStreetMap を使用
class WebMapScreen extends StatefulWidget {
  const WebMapScreen({super.key});

  @override
  State<WebMapScreen> createState() => _WebMapScreenState();
}

class _WebMapScreenState extends State<WebMapScreen> {
  final MapController _mapController = MapController();
  final SummaryService _summaryService = SummaryService();

  double _timelineProgress = 1.0;
  late List<geo.Position> _demoPath;
  late List<DemoPhotoMemory> _demoPhotos;

  @override
  void initState() {
    super.initState();
    _demoPath = DemoData.samplePath;
    _demoPhotos = DemoData.samplePhotos;
  }

  void _showSummary() {
    final summary = _summaryService.generateSummary(
      path: _demoPath,
      photos: [], // デモでは空
    );
    showDialog(
      context: context,
      builder: (context) => SummaryDialog(summary: summary),
    );
  }

  List<LatLng> _getVisiblePath() {
    final visibleCount = (_demoPath.length * _timelineProgress).toInt();
    if (visibleCount < 2) return [];
    return _demoPath
        .take(visibleCount)
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();
  }

  List<DemoPhotoMemory> _getVisiblePhotos() {
    return _demoPhotos.where((photo) {
      final idx = _demoPhotos.indexOf(photo);
      return (idx / _demoPhotos.length) <= _timelineProgress;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visiblePath = _getVisiblePath();
    final visiblePhotos = _getVisiblePhotos();

    return Scaffold(
      body: Stack(
        children: [
          // 地図（flutter_map + OpenStreetMap Dark）
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(35.6680, 139.6990),
              initialZoom: 14.0,
              backgroundColor: const Color(0xFF1a1a2e),
            ),
            children: [
              // ダークテーマのタイルレイヤー
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.tracememories.app',
                retinaMode: true,
              ),

              // 軌跡ライン
              if (visiblePath.length >= 2)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: visiblePath,
                      color: AppTheme.accentBlue,
                      strokeWidth: 5.0,
                    ),
                  ],
                ),

              // 写真マーカー
              MarkerLayer(
                markers: visiblePhotos.map((photo) {
                  return Marker(
                    point: LatLng(photo.latitude, photo.longitude),
                    width: 120,
                    height: 100,
                    child: _buildPhotoMarker(photo),
                  );
                }).toList(),
              ),
            ],
          ),

          // デモモードバナー
          _buildDemoBanner(),

          // アプリタイトル
          _buildAppTitle(),

          // ステータスインジケーター
          _buildStatusIndicator(visiblePhotos.length),

          // タイムラインバー
          _buildTimelineBar(),

          // サマリーボタン
          _buildSummaryButton(),

          // 設定ボタン
          _buildSettingsButton(),
        ],
      ),
    );
  }

  Widget _buildPhotoMarker(DemoPhotoMemory photo) {
    return GestureDetector(
      onTap: () {
        _mapController.move(
          LatLng(photo.latitude, photo.longitude),
          16.0,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: AppTheme.glassGradient,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('📸', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      '${photo.dateTime.hour}:${photo.dateTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  photo.label,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          CustomPaint(
            size: const Size(12, 8),
            painter: _TrianglePainter(),
          ),
        ],
      ),
    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).fadeIn();
  }

  Widget _buildDemoBanner() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 70,
      left: 20,
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        borderRadius: BorderRadius.circular(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'デモモード — 渋谷〜原宿散歩',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 1200.ms),
    );
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
                color: Colors.white,
                letterSpacing: -1.5,
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
            'あなたの日々を、地図に刻む',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
    );
  }

  Widget _buildStatusIndicator(int photoCount) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 25,
      right: 60,
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        borderRadius: BorderRadius.circular(30),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, size: 14, color: AppTheme.accentBlue),
            const SizedBox(width: 6),
            Text(
              '$photoCount の思い出',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _buildTimelineBar() {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 30,
      left: 20,
      right: 20,
      child: TimelineBar(
        selectedDate: DateTime.now(),
        progress: _timelineProgress,
        isLive: _timelineProgress > 0.95,
        onProgressChanged: (value) {
          setState(() => _timelineProgress = value);
        },
      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.5, end: 0),
    );
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

  Widget _buildSettingsButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      right: 20,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        ),
        child: GlassContainer(
          padding: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(30),
          child: const Icon(Icons.settings, size: 18, color: AppTheme.textSecondary),
        ),
      ),
    ).animate().fadeIn(delay: 800.ms);
  }
}

/// マーカー下部の三角形
class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
