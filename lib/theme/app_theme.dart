import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryDark = Color(0xFF0F172A);
  static const Color secondaryDark = Color(0xFF1E293B);
  static const Color surfaceDark = Color(0xFF334155);
  static const Color accentBlue = Color(0xFF38BDF8);
  static const Color accentPurple = Color(0xFF818CF8);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  
  // Glassmorphism
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const double glassBlur = 12.0;
  
  // Gradients
  static const LinearGradient routeGradient = LinearGradient(
    colors: [accentBlue, accentPurple],
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x0DFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const RadialGradient backgroundGradient = RadialGradient(
    colors: [secondaryDark, primaryDark],
    center: Alignment.center,
    radius: 1.0,
  );
  
  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryDark,
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        secondary: accentPurple,
        surface: secondaryDark,
        error: Color(0xFFEF4444),
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
  
  // Box Decorations
  static BoxDecoration get glassDecoration {
    return BoxDecoration(
      color: glassBackground,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: glassBorder, width: 1),
    );
  }
  
  static BoxDecoration get photoCardDecoration {
    return BoxDecoration(
      color: glassBackground,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: glassBorder, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}
