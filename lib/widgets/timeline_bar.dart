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
  static const double _handleSize = 20;
  static const double _trackHeight = 4;
  static const double _hitTargetHeight = 40;

  void _updateProgress(double localX, double trackWidth) {
    if (widget.onProgressChanged == null || trackWidth <= 0) return;
    widget.onProgressChanged!((localX / trackWidth).clamp(0.0, 1.0));
  }

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
              Text(
                _formatDate(widget.selectedDate),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final trackWidth = constraints.maxWidth;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragUpdate: (details) =>
                          _updateProgress(details.localPosition.dx, trackWidth),
                      onTapUp: (details) =>
                          _updateProgress(details.localPosition.dx, trackWidth),
                      child: SizedBox(
                        height: _hitTargetHeight,
                        child: Center(
                          child: SizedBox(
                            height: _trackHeight,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceDark,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: widget.progress,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: AppTheme.routeGradient,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: (widget.progress * trackWidth) -
                                      _handleSize / 2,
                                  top: -(_handleSize - _trackHeight) / 2,
                                  child: Container(
                                    width: _handleSize,
                                    height: _handleSize,
                                    decoration: BoxDecoration(
                                      color: AppTheme.accentBlue,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.accentBlue
                                              .withValues(alpha: 0.5),
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
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
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
