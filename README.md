# TraceMemories

> **あなたの日々を、地図に刻む**

日々の移動を美しい軌跡として可視化し、撮影した写真を地図上に配置する——
TraceMemoriesは、あなたの「今日」を「思い出」に変えるアプリです。

---

## 主な機能

| 機能 | 説明 |
|------|------|
| リアルタイム軌跡描画 | 移動ルートを滑らかな曲線として地図上に描画 |
| 思い出の自動マッピング | 位置情報付き写真を地図上へ自動配置 |
| タイムライン・スクラブ | スライダーで時間を遡り、一日を映画のように再生 |
| 3D ダークマップ | 夜の街並みを 3D ビルディングと共に表現 |
| 今日のふりかえり | 歩いた距離や写真をやさしい言葉でまとめたサマリーを生成 |
| Web デモモード | ブラウザ上でサンプルデータを使った体験が可能 |

---

## 技術スタック

| 分類 | 技術 |
|------|------|
| フレームワーク | Flutter 3.x (Dart 3.x) |
| 地図（ネイティブ） | mapbox_maps_flutter |
| 地図（Web） | flutter_map + OpenStreetMap (CartoDB Dark) |
| 位置情報 | geolocator |
| 写真 | photo_manager |
| 環境変数 | flutter_dotenv |
| アニメーション | flutter_animate |
| フォント | google_fonts (Inter) |
| デザイン | グラスモーフィズム UI |

---

## 対応プラットフォーム

| プラットフォーム | 状態 | 備考 |
|----------------|------|------|
| iOS | 対応 | Mapbox SDK 使用 |
| Android | 対応 | Mapbox SDK 使用 |
| Web | 対応 | デモモード (OpenStreetMap) |
| macOS | 対応 | Mapbox SDK 使用 |

---

## セットアップ

### 前提条件

- Flutter SDK 3.x 以上
- Dart SDK 3.x 以上
- Mapbox アカウント（ネイティブ版）

### 1. リポジトリのクローン

```bash
git clone https://github.com/your-username/trace-memories.git
cd trace-memories
```

### 2. 依存関係のインストール

```bash
flutter pub get
```

### 3. 環境変数の設定（ネイティブ版のみ）

プロジェクトルートに `.env` ファイルを作成:

```env
MAPBOX_PUBLIC_TOKEN=pk.your_public_token
MAPBOX_SECRET_TOKEN=sk.your_secret_token
```

> `.env` は `.gitignore` で保護されています。絶対にコミットしないでください。

### 4. プラットフォーム別の追加設定

- **iOS**: Mapbox SDK の認証に `~/.netrc` への Secret Token 設定が必要
- **Android**: `android/gradle.properties` に `MAPBOX_DOWNLOADS_TOKEN` を設定
- **Web**: 追加設定不要（デモモードで動作）

### 5. 実行

```bash
# iOS / Android
flutter run

# Web（デモモード）
flutter run -d chrome --web-port=8080

# リリースビルド（Web）
flutter build web --release
```

---

## プロジェクト構成

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

---

## 開発

```bash
# 静的解析（エラー 0 件を維持）
flutter analyze

# テスト実行（全件パスを維持）
flutter test
```

詳細は以下のドキュメントを参照してください:

| ドキュメント | 内容 |
|------------|------|
| [CLAUDE.md](./CLAUDE.md) | AI エージェント向けプロジェクト指示書 |
| [AGENTS.md](./AGENTS.md) | AI エージェント作業ガイドライン |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | コントリビューション手順 |
| [ARCHITECTURE.md](./ARCHITECTURE.md) | アーキテクチャ概要 |
| [DEBUG_GUIDE.md](./DEBUG_GUIDE.md) | 開発・デバッグガイド |
| [DEVELOPMENT_RULES.md](./DEVELOPMENT_RULES.md) | 開発・セキュリティ規約 |
| [SECURITY.md](./SECURITY.md) | セキュリティポリシー |
| [CHANGELOG.md](./CHANGELOG.md) | 変更履歴 |
| [TODO.md](./TODO.md) | 残タスク一覧 |

---

## ロードマップ

- [x] コア UI & マップ統合
- [x] リアルタイム位置トラッキング
- [x] 写真ライブラリ連携
- [x] 今日のふりかえり機能
- [x] オンボーディング画面
- [x] 設定画面（利用規約・プライバシーポリシー・OSS ライセンス）
- [ ] SQLite によるデータ永続化
- [ ] SharedPreferences によるオンボーディング完了フラグ
- [ ] クラウド同期（Firebase Firestore）
- [ ] 思い出の動画書き出し
- [ ] 多言語対応

---

## ライセンス

本プロジェクトは非公開です。無断での複製・配布を禁止します。

---

<p align="center">
Developed with care by <strong>Pi</strong>
</p>
