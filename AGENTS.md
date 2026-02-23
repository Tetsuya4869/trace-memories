# AGENTS.md

AI エージェントがこのプロジェクトで作業する際のガイドラインです。

## プロジェクト概要

**TraceMemories** — Flutter 製クロスプラットフォームアプリ（iOS / Android / Web）。
GPS 軌跡と写真を地図上に可視化する個人向け日記アプリ。

## セットアップ

```bash
flutter pub get
flutter analyze   # エラー0件を確認
flutter test      # 全件パスを確認
```

## ブランチ戦略

| ブランチ | 用途 |
|----------|------|
| `main` | 安定版 |
| `feature/xxx` | 機能追加 |
| `fix/xxx` | バグ修正 |
| `release/xxx` | リリース準備 |

## PR を作成する際のルール

1. `flutter analyze` がエラー0件であること
2. `flutter test` が全件パスであること
3. PR タイトルは絵文字プレフィックスを付ける
   - `✨ feat:` 機能追加
   - `🐛 fix:` バグ修正
   - `♻️ refactor:` リファクタリング
   - `📝 docs:` ドキュメント
   - `🧪 test:` テスト

## 重要ファイル

| ファイル | 説明 |
|----------|------|
| `lib/theme/app_theme.dart` | デザイントークン（色・グラデーション・スタイル） |
| `lib/screens/map_screen.dart` | ネイティブ版メイン画面 |
| `lib/screens/web_map_screen.dart` | Web版メイン画面（デモモード） |
| `lib/services/location_service.dart` | GPS トラッキング |
| `lib/services/photo_service.dart` | 写真ライブラリアクセス |
| `TODO.md` | 残タスク一覧 |
| `CHANGELOG.md` | 変更履歴 |
| `privacy_policy.md` | プライバシーポリシー |

## 禁止事項

- `.env` を `pubspec.yaml` の `assets` セクションに追加しない
- `withOpacity()` を使わない（`withValues(alpha:)` を使う）
- `StreamController` / `StreamSubscription` を dispose せずに放置しない
- ハードコードされた色・サイズを追加しない（`AppTheme` の定数を使う）
- テストが壊れたままコミットしない

## 未実装の主要機能（作業前に確認）

- **データ永続化**: `sqflite` は依存に含まれているが未使用。軌跡・写真・サマリーの保存は未実装
- **SharedPreferences**: オンボーディング完了フラグ等の永続化が未実装
- **クラウド同期**: ロードマップ記載だが未着手

詳細は [TODO.md](./TODO.md) を参照。
