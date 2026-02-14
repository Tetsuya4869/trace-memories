import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';
import 'screens/map_screen.dart';
import 'screens/web_map_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {
    // .env がなくても続行（Web版はデモモード、ネイティブ版はトークン未設定状態）
  }

  // Set system UI overlay style for immersive experience (native only)
  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.primaryDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

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
      home: kIsWeb ? const WebMapScreen() : const OnboardingGate(),
    );
  }
}

/// 初回起動時はオンボーディング、2回目以降はMapScreenを表示
class OnboardingGate extends StatefulWidget {
  const OnboardingGate({super.key});

  @override
  State<OnboardingGate> createState() => _OnboardingGateState();
}

class _OnboardingGateState extends State<OnboardingGate> {
  bool _showOnboarding = true;

  void _completeOnboarding() {
    setState(() => _showOnboarding = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return OnboardingScreen(onComplete: _completeOnboarding);
    }
    return const MapScreen();
  }
}
