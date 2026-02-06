# CLAUDE.md — TraceMemories

このファイルは、AIアシスタントが本コードベースを理解・開発するためのガイドです。

## プロジェクト概要

TraceMemoriesは、日々の移動を美しい軌跡として3Dダークマップ上に可視化し、位置情報付き写真を自動配置するFlutterアプリ。タイムラインスクラバーで一日を映画のように再生でき、一日の終わりにポエティックなふりかえりサマリーを生成する。

**タグライン:** あなたの日々を、地図に刻む

## 技術スタック

- **言語:** Dart (SDK ^3.10.7)
- **フレームワーク:** Flutter + Material Design 3
- **地図:** mapbox_maps_flutter (ネイティブ iOS/Android)、flutter_map + OpenStreetMap (Web版フォールバック)
- **位置情報:** geolocator + permission_handler
- **写真:** photo_manager
- **UI/アニメーション:** flutter_animate、google_fonts (Interフォント)
- **環境変数:** flutter_dotenv (.envファイルでAPIトークン管理)
- **ストレージ:** sqflite、path_provider (将来利用予定)
- **リンター:** flutter_lints (analysis_options.yaml)

## よく使うコマンド

```bash
# 依存関係のインストール
flutter pub get

# 静的解析 / リント
flutter analyze

# テスト実行
flutter test

# ディープクリーン（ビルドが壊れた時に使用）
flutter clean && flutter pub get

# プラットフォーム別実行
flutter run -d chrome        # Web版デモモード
flutter run -d ios            # iOS シミュレータ/実機
flutter run -d android        # Android エミュレータ/実機
```

## プロジェクト構造

```
lib/
├── main.dart                 # エントリーポイント、アプリ初期化
├── screens/
│   ├── map_screen.dart       # ネイティブ地図画面 (Mapbox, iOS/Android)
│   └── web_map_screen.dart   # Webデモモード (OpenStreetMap フォールバック)
├── widgets/
│   ├── glass_container.dart  # グラスモーフィズム基本コンポーネント
│   ├── photo_card.dart       # 写真メモリーカード表示
│   ├── timeline_bar.dart     # タイムラインスクラバー
│   └── summary_dialog.dart   # ふりかえりサマリーダイアログ
├── services/
│   ├── location_service.dart # GPS追跡 (geolocator Streamベース)
│   ├── photo_service.dart    # 写真ライブラリ連携
│   ├── summary_service.dart  # テンプレートベースのサマリー生成
│   └── demo_data.dart        # Webデモ用モックデータ
└── theme/
    └── app_theme.dart        # デザインシステム: カラー、グラスモーフィズム、タイポグラフィ
```

### プラットフォームディレクトリ

`android/`, `ios/`, `macos/`, `linux/`, `windows/`, `web/` — プラットフォーム固有のビルド設定。ネイティブプラグイン追加やパーミッション変更時のみ編集が必要。

## アーキテクチャとパターン

### 状態管理
- 画面は **StatefulWidget** + ローカルstate で管理
- ServiceクラスはScreenで直接インスタンス化 (DIコンテナ不使用)
- **Dart Stream** によるリアクティブなデータフロー (例: `LocationService.pathStream`)

### ウィジェット構成
- 画面は `Stack` でレイヤード UI (地図ベース + オーバーレイ群)
- 再利用ウィジェット (`GlassContainer`, `PhotoCard`, `TimelineBar`) はプレゼンテーション専用 — ビジネスロジックを含まない
- コンストラクタパラメータのみで設定

### 地図レンダリング
- ネイティブ: `MapboxMap` + `PolylineAnnotationManager` でルート描画
- Web: `FlutterMap` + `PolylineLayer` (CartoDB Dark タイル)
- 両方とも `flyTo()` によるカメラアニメーション対応

### タイムラインシステム
- 進捗値 float (0.0〜1.0) でルート表示と写真フィルタリングを制御
- 進捗に応じてポリラインを毎フレーム再描画
- `pixelForCoordinate()` で緯度経度をスクリーン座標に変換して写真カードを配置

## デザインシステム

### カラーパレット (ダークグラスモーフィズムテーマ)
- プライマリダーク: `#0F172A` — セカンダリダーク: `#1E293B` — サーフェス: `#334155`
- アクセントブルー: `#38BDF8` — アクセントパープル: `#818CF8`
- テキスト: `#FFFFFF` (プライマリ)、`#94A3B8` (セカンダリ)

### グラスモーフィズム定数
- 背景: 10%ホワイトオーバーレイ — ボーダー: 20%ホワイト — ブラー: 12px
- 角丸: 20px (コンテナ)、12px (カード)、8px (小要素)

### タイポグラフィ
- フォント: Inter (google_fonts経由)
- Material Design 3 テキストスケール

## 機密情報と環境設定

**重要:** ソースコード内にAPIキーを直接記述することは厳禁。

- `.env` — Mapboxトークン (`MAPBOX_PUBLIC_TOKEN`, `MAPBOX_SECRET_TOKEN`)。flutter_dotenvで起動時にロード。pubspec.yamlでFlutterアセットとして登録済み。
- `android/gradle.properties` — `MAPBOX_DOWNLOADS_TOKEN` (Mapbox SDKダウンロード用)
- `ios/MapboxSecrets.plist` — iOS用Mapbox認証
- 全ての機密ファイルは `.gitignore` に登録済み。絶対にコミットしないこと。

Web版デモモードは `.env` なしでも OpenStreetMap タイルにフォールバックして動作する。

## コード規約

- **Flutter/Dart公式スタイルガイド** に準拠 (flutter_lintsで強制)
- パフォーマンスのため `const` コンストラクタを積極的に使用
- Null Safety有効 (Dart 3.10+)
- ファイル名: `snake_case.dart`
- クラス名: `PascalCase`
- プライベートメンバー: アンダースコアプレフィックス (`_currentPath`)

### フォルダルール
- `lib/screens/` — 画面単位のウィジェットのみ
- `lib/widgets/` — 再利用可能なプレゼンテーション専用コンポーネント
- `lib/services/` — ビジネスロジック、UIコードを含まない
- `lib/theme/` — デザイントークンとテーマ定義
- `lib/models/` — データモデルクラス (将来利用予定)

## Git規約

### ブランチ戦略
- `main` — 安定版、常に動作可能な状態を維持
- `feature/xxx` または `fix/xxx` — トピックブランチで開発

### コミットメッセージ
絵文字プレフィックスを使用:
- `✨` 機能追加
- `🐛` バグ修正
- `📝` ドキュメント
- `🚀` パフォーマンス / リリース
- `🎨` デザイン変更
- `📖` ドキュメント大規模更新

### コミット前チェック
`.env`, `gradle.properties`, `key.properties`, `MapboxSecrets.plist` がステージングされていないことを必ず確認すること。

## テスト

- フレームワーク: `flutter_test` (Flutter組み込み)
- テストファイル: `test/` ディレクトリ
- 実行: `flutter test`
- 現在のカバレッジ: 最小限 — `test/widget_test.dart` にプレースホルダーテストのみ（テンプレートのまま、実際のアプリとは不一致）
- 静的解析: `flutter analyze` (コミット前に実行すること)

## ドキュメント一覧

- `README.md` — プロジェクト紹介とセットアップ手順
- `DEVELOPMENT_RULES.md` — セキュリティ・開発ワークフロー規約
- `DEBUG_GUIDE.md` — デバッグ、ホットリロード、トラブルシューティング
- `SUMMARY_PLAN.md` — AIサマリー機能の実装計画
- `docs/privacy_policy.html` — プライバシーポリシー

## コミュニケーション

- ドキュメントやコミットメッセージの主要言語: **日本語**
- ソースコード (変数名、関数名) は **英語**
- 重大な技術選定やデザイン変更を行う際は、必ずユーザーに提案して承認を得ること

## 既知の課題と改善余地

- `test/widget_test.dart` はFlutterテンプレートのまま (`MyApp` を参照) で実行時にエラーになる
- `LocationService.dispose()` メソッドがなく、StreamControllerが閉じられない
- `PhotoMemory` データクラスが `photo_service.dart` 内で定義されており、独立した `models/` ファイルがない
- `provider` パッケージが依存関係にあるが、実際のコードでは未使用
- 写真取得が先頭100件のハードコードされた制限で、日付フィルタリング前に実行される
