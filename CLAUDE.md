# CLAUDE.md

Claude Code がこのプロジェクトで作業する際の指示書です。

## プロジェクト概要

**TraceMemories** — 日々の移動軌跡と写真を地図上に可視化する Flutter アプリ。
- iOS / Android / Web / macOS 対応
- バージョン: 1.0.0
- 言語: Dart / Flutter

## 技術スタック

| 分類 | 技術 |
|------|------|
| フレームワーク | Flutter (Dart) |
| 地図（ネイティブ） | mapbox_maps_flutter |
| 地図（Web） | flutter_map + OpenStreetMap |
| 位置情報 | geolocator |
| 写真 | photo_manager |
| 環境変数 | flutter_dotenv |
| アニメーション | flutter_animate |
| フォント | google_fonts (Inter) |

## ディレクトリ構成

```
lib/
├── main.dart               # エントリーポイント + OnboardingGate
├── screens/
│   ├── map_screen.dart     # メイン画面（ネイティブ）
│   ├── web_map_screen.dart # メイン画面（Web・デモモード）
│   ├── onboarding_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── glass_container.dart
│   ├── photo_card.dart
│   ├── summary_dialog.dart
│   └── timeline_bar.dart
├── services/
│   ├── location_service.dart
│   ├── photo_service.dart
│   ├── summary_service.dart
│   └── demo_data.dart
└── theme/
    └── app_theme.dart
```

## 開発時の重要ルール

### コマンド

```bash
# 依存関係インストール
flutter pub get

# 静的解析（エラー0件を維持すること）
flutter analyze

# テスト実行（全件パスを維持すること）
flutter test

# Web版デモ起動
flutter run -d chrome --web-port=8080

# リリースビルド（Web）
flutter build web --release
```

### コーディング規約

- **日本語対応**: UIテキストは日本語。コメントは英語でも日本語でも可
- **テーマ**: `AppTheme` の定数を使うこと。マジックナンバーで色を直書きしない
- **グラスモーフィズム**: `GlassContainer` ウィジェットを再利用すること
- **プラットフォーム分岐**: `kIsWeb` で Web / ネイティブを切り替える
- **deprecated API**: `withOpacity()` は使わない → `withValues(alpha:)` を使う
- **null安全**: `!` による強制アンラップは避け、null チェックを先に行う

### 禁止事項

- `.env` を `pubspec.yaml` の assets に追加しない（APIキー漏洩）
- `StreamController` / `StreamSubscription` を `dispose` せずに放置しない
- `print()` をリリースコードに残さない

### 環境変数

ネイティブ版はプロジェクトルートの `.env` ファイルが必要（`.gitignore` 対象）:

```
MAPBOX_PUBLIC_TOKEN=pk.xxxxx
MAPBOX_SECRET_TOKEN=sk.xxxxx
```

Web版はデモモードで動作するため `.env` 不要。

## 未実装・残タスク

詳細は [TODO.md](./TODO.md) を参照。

優先度高:
1. SQLite によるデータ永続化（軌跡・写真・サマリー）
2. SharedPreferences によるオンボーディング完了フラグ
3. Apple Developer Program 登録 → TestFlight リリース

## テスト方針

- `test/widget_test.dart` にユニットテストを追加していく
- `SummaryService` / 距離計算など、純粋な関数はユニットテストで検証
- `flutter test` が常に全件パスする状態を維持すること
