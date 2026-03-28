import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trace_memories/theme/app_theme.dart';
import 'package:trace_memories/widgets/summary_dialog.dart';
import '../helpers/test_helpers.dart';

void main() {
  initTestEnvironment();
  group('SummaryDialog', () {
    testWidgets('サマリーテキストが表示される', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: SummaryDialog(summary: 'テストサマリー'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('テストサマリー'), findsOneWidget);
    });

    testWidgets('タイトルが表示される', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: SummaryDialog(summary: 'テスト'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('今日のふりかえり'), findsOneWidget);
    });

    testWidgets('おやすみなさいボタンが表示される', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: SummaryDialog(summary: 'テスト'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('おやすみなさい'), findsOneWidget);
    });

    testWidgets('閉じるボタンが存在する', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: SummaryDialog(summary: 'テスト'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}
