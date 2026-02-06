import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TimelineBar extends StatefulWidget {
  final DateTime selectedDate;
  final double progress; // 0.0 to 1.0
  final ValueChanged<double>? onProgressChanged;
  final bool isLive;
  
  const TimelineBar({
    super.key,
    required this.selectedDate,
    required this.progress,
    this.onProgressChanged,
    this.isLive = false,
  });

  @override
  State<TimelineBar> createState() => _TimelineBarState();
}

class _TimelineBarState extends State<TimelineBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppTheme.primaryDark.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.glassBorder, width: 1),
          ),
          child: Row(
            children: [
              // Date display
              Text(
                _formatDate(widget.selectedDate),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 15),
              // Slider
              Expanded(
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (widget.onProgressChanged != null) {
                      final RenderBox box = context.findRenderObject() as RenderBox;
                      final width = box.size.width - 150; // Account for padding and text
                      final newProgress = (details.localPosition.dx - 80) / width;
                      widget.onProgressChanged!(newProgress.clamp(0.0, 1.0));
                    }
                  },
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Progress fill
                        FractionallySizedBox(
                          widthFactor: widget.progress,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppTheme.routeGradient,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        // Handle
                        Positioned(
                          left: (widget.progress * (MediaQuery.of(context).size.width - 200)) - 10,
                          top: -8,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppTheme.accentBlue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.accentBlue.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // Live indicator
              if (widget.isLive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: AppTheme.accentBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 
                    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return '${months[date.month - 1]} ${date.day}';
  }
}
