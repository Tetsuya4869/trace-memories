import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';
import 'screens/map_screen.dart';
import 'screens/web_map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (native only, web uses demo mode)
  if (!kIsWeb) {
    try {
      await dotenv.load(fileName: ".env");
    } catch (_) {
      // .env がなくても続行
    }
  }

  // Set system UI overlay style for immersive experience (native only)
  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.primaryDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    // Enable edge-to-edge
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  runApp(const TraceMemoriesApp());
}

class TraceMemoriesApp extends StatelessWidget {
  const TraceMemoriesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TraceMemories',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // Web版ではデモモードのWebMapScreen、それ以外ではMapScreen
      home: kIsWeb ? const WebMapScreen() : const MapScreen(),
    );
  }
}
