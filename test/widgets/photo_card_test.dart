import 'package:flutter_test/flutter_test.dart';
import 'package:trace_memories/widgets/photo_card.dart';
import '../helpers/test_helpers.dart';

void main() {
  initTestEnvironment();
  group('PhotoCard', () {
    testWidgets('時刻とロケーションを表示する', (tester) async {
      await tester.pumpWidget(wrapWithMaterialApp(
        const PhotoCard(
          emoji: '📸',
          time: '14:30',
          location: '渋谷駅',
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('14:30'), findsOneWidget);
      expect(find.text('渋谷駅'), findsOneWidget);
    });

    testWidgets('imageBytes未設定時にemojiが表示される', (tester) async {
      await tester.pumpWidget(wrapWithMaterialApp(
        const PhotoCard(
          emoji: '📷',
          time: '10:00',
          location: 'テスト',
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('📷'), findsOneWidget);
    });

    testWidgets('onTapコールバックが呼ばれる', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithMaterialApp(
        PhotoCard(
          emoji: '📸',
          time: '14:30',
          location: '渋谷',
          onTap: () => tapped = true,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('14:30'));
      expect(tapped, isTrue);
    });
  });
}
