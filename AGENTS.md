# AGENTS.md

AI エージェントがこのプロジェクトで作業する際のガイドラインです。

## プロジェクト概要

**TraceMemories** — Flutter 製クロスプラットフォームアプリ（iOS / Android / Web / macOS）。
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
| `ARCHITECTURE.md` | アーキテクチャ概要 |
| `privacy_policy.md` | プライバシーポリシー |

## コーディング規約

### 必須パターン

| パターン | 理由 |
|----------|------|
| `if (!mounted) return;` を async gap 後に挿入 | `setState() called after dispose()` の防止 |
| SDK 初期化は `initState()` で一度だけ実行 | `build()` は副作用禁止。毎フレーム呼ばれる |
| `FutureBuilder.future` にはキャッシュ済みの Future を渡す | 毎 build で新しい Future を生成しない |
| I/O 操作（カメラ・GPS・写真）には try-catch を付ける | プラットフォームチャネルの例外でクラッシュさせない |
| Stream の `listen` には `onError` ハンドラを付ける | 未処理エラーの伝播防止 |
| Nullable フィールドはローカル変数にバインドしてから使う | `!` 強制アンラップの回避 |
| リスト走査は `take()` / `indexed` を使う | `indexOf()` による O(n^2) の防止 |
| Controller は必ず `dispose()` で破棄する | メモリリーク防止 |
| Timer は `dispose()` で `cancel()` する | リーク防止 |

### 例: ローカル変数バインド

```dart
// NG: 強制アンラップ
if (photo.latitude != null && photo.longitude != null) {
  flyTo(Position(photo.longitude!, photo.latitude!));
}

// OK: ローカル変数にバインド
final lat = photo.latitude;
final lng = photo.longitude;
if (lat != null && lng != null) {
  flyTo(Position(lng, lat));
}
```

### 例: debounce パターン

```dart
Timer? _debounce;

onCameraChange: (_) {
  _debounce?.cancel();
  _debounce = Timer(const Duration(milliseconds: 100), () {
    if (mounted) setState(() {});
  });
},

@override
void dispose() {
  _debounce?.cancel();
  super.dispose();
}
```

## 禁止事項

- `.env` を `pubspec.yaml` の `assets` セクションに追加しない
- `withOpacity()` を使わない（`withValues(alpha:)` を使う）
- `StreamController` / `StreamSubscription` を dispose せずに放置しない
- ハードコードされた色・サイズを追加しない（`AppTheme` の定数を使う）
- テストが壊れたままコミットしない
- `print()` をリリースコードに残さない
- `build()` 内で副作用のある処理を実行しない

## 未実装の主要機能（作業前に確認）

- **データ永続化**: `sqflite` は依存に含まれているが未使用。軌跡・写真・サマリーの保存は未実装
- **SharedPreferences**: オンボーディング完了フラグ等の永続化が未実装
- **クラウド同期**: ロードマップ記載だが未着手

詳細は [TODO.md](./TODO.md) を参照。
