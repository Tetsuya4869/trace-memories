import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_memories/widgets/glass_container.dart';
import '../helpers/test_helpers.dart';

void main() {
  initTestEnvironment();
  group('GlassContainer', () {
    testWidgets('childを描画する', (tester) async {
      await tester.pumpWidget(wrapWithMaterialApp(
        const GlassContainer(child: Text('テスト')),
      ));
      expect(find.text('テスト'), findsOneWidget);
    });

    testWidgets('カスタムpaddingが適用される', (tester) async {
      await tester.pumpWidget(wrapWithMaterialApp(
        const GlassContainer(
          padding: EdgeInsets.all(32),
          child: Text('パディング'),
        ),
      ));
      expect(find.text('パディング'), findsOneWidget);
    });

    testWidgets('カスタムborderRadiusが適用される', (tester) async {
      await tester.pumpWidget(wrapWithMaterialApp(
        GlassContainer(
          borderRadius: BorderRadius.circular(10),
          child: const Text('ボーダー'),
        ),
      ));
      expect(find.text('ボーダー'), findsOneWidget);
    });

    testWidgets('BackdropFilterが含まれる', (tester) async {
      await tester.pumpWidget(wrapWithMaterialApp(
        const GlassContainer(child: Text('ブラー')),
      ));
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });
}
