import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trace_memories/theme/app_theme.dart';

/// テスト用のMaterialAppラッパー
Widget wrapWithMaterialApp(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: Scaffold(body: child),
  );
}

/// テスト環境の初期化（google_fontsのHTTPリクエストを無効化）
void initTestEnvironment() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
}
