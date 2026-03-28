import 'package:flutter_test/flutter_test.dart';
import 'package:trace_memories/widgets/timeline_bar.dart';
import '../helpers/test_helpers.dart';

void main() {
  initTestEnvironment();
  group('TimelineBar', () {
    testWidgets('日付がフォーマットされて表示される', (tester) async {
      await tester.pumpWidget(wrapWithMaterialApp(
        TimelineBar(
          selectedDate: DateTime(2026, 3, 28),
          progress: 0.5,
        ),
      ));

      expect(find.text('MAR 28'), findsOneWidget);
    });

    testWidgets('1月の日付が正しくフォーマットされる', (tester) async {
      await tester.pumpWidget(wrapWithMaterialApp(
        TimelineBar(
          selectedDate: DateTime(2026, 1, 15),
          progress: 0.5,
        ),
      ));

      expect(find.text('JAN 15'), findsOneWidget);
    });

    testWidgets('isLive=trueでLIVEテキストが表示される', (tester) async {
      await tester.pumpWidget(wrapWithMaterialApp(
        TimelineBar(
          selectedDate: DateTime(2026, 3, 28),
          progress: 1.0,
          isLive: true,
        ),
      ));

      expect(find.text('LIVE'), findsOneWidget);
    });

    testWidgets('isLive=falseでLIVEテキストが表示されない', (tester) async {
      await tester.pumpWidget(wrapWithMaterialApp(
        TimelineBar(
          selectedDate: DateTime(2026, 3, 28),
          progress: 0.5,
          isLive: false,
        ),
      ));

      expect(find.text('LIVE'), findsNothing);
    });
  });
}
