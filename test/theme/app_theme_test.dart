import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_memories/theme/app_theme.dart';
import '../helpers/test_helpers.dart';

void main() {
  initTestEnvironment();

  group('AppTheme', () {
    testWidgets('darkThemeがダークブライトネス', (tester) async {
      // google_fontsがbinding要求するためtestWidgets内で実行
      final theme = AppTheme.darkTheme;
      expect(theme.brightness, Brightness.dark);
    });

    test('primaryDarkが正しい色', () {
      expect(AppTheme.primaryDark, const Color(0xFF0F172A));
    });

    test('accentBlueが正しい色', () {
      expect(AppTheme.accentBlue, const Color(0xFF38BDF8));
    });

    test('accentPurpleが正しい色', () {
      expect(AppTheme.accentPurple, const Color(0xFF818CF8));
    });

    test('glassDecorationが正しい設定', () {
      final decoration = AppTheme.glassDecoration;
      expect(decoration.color, AppTheme.glassBackground);
      expect(decoration.border, isNotNull);
    });

    test('photoCardDecorationが正しい設定', () {
      final decoration = AppTheme.photoCardDecoration;
      expect(decoration.color, AppTheme.glassBackground);
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, 1);
    });

    test('glassGradientが定義されている', () {
      expect(AppTheme.glassGradient, isA<LinearGradient>());
      expect(AppTheme.glassGradient.colors.length, 2);
    });

    test('routeGradientが定義されている', () {
      expect(AppTheme.routeGradient, isA<LinearGradient>());
      expect(AppTheme.routeGradient.colors, contains(AppTheme.accentBlue));
    });

    test('glassBlurが正の値', () {
      expect(AppTheme.glassBlur, greaterThan(0));
    });
  });
}
