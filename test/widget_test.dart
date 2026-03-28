import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_memories/main.dart';
import 'helpers/test_helpers.dart';

void main() {
  initTestEnvironment();
  testWidgets('TraceMemoriesApp スモークテスト', (WidgetTester tester) async {
    await tester.pumpWidget(const TraceMemoriesApp());
    await tester.pump();

    // テスト環境では kIsWeb == false なので OnboardingGate が表示される
    if (!kIsWeb) {
      // OnboardingScreenまたはMapScreenが表示されるはず
      expect(find.byType(TraceMemoriesApp), findsOneWidget);
    }
  });
}
