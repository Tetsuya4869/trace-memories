import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/photo_card.dart';
import '../widgets/timeline_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double _timelineProgress = 0.3;
  
  // Sample data for demo
  final List<Map<String, dynamic>> _samplePhotos = [
    {'emoji': '🏔️', 'time': '10:30 AM', 'location': 'Mt. Fuji Area', 'top': 0.25, 'left': 0.1},
    {'emoji': '🍜', 'time': '01:15 PM', 'location': 'Kawaguchiko', 'top': 0.4, 'left': 0.4},
    {'emoji': '🌸', 'time': '04:00 PM', 'location': 'Park Center', 'top': 0.2, 'left': 0.7},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [AppTheme.secondaryDark, AppTheme.primaryDark],
            center: Alignment.center,
            radius: 1.5,
          ),
        ),
        child: Stack(
          children: [
            // Grid overlay (placeholder for map)
            _buildMapPlaceholder(),
            
            // Route line
            _buildRouteLine(),
            
            // Photo cards
            ..._buildPhotoCards(),
            
            // App title
            _buildAppTitle(),
            
            // Timeline bar
            _buildTimelineBar(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMapPlaceholder() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.4,
        child: CustomPaint(
          painter: GridPainter(),
        ),
      ),
    );
  }
  
  Widget _buildRouteLine() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.5,
      left: MediaQuery.of(context).size.width * 0.1,
      right: MediaQuery.of(context).size.width * 0.1,
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          gradient: AppTheme.routeGradient,
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentBlue.withOpacity(0.5),
              blurRadius: 20,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0);
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
            // TODO: Show photo detail
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

// Custom painter for grid background
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.surfaceDark
      ..strokeWidth = 1;
    
    const spacing = 50.0;
    
    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
