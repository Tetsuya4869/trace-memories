# Changelog

## [1.0.1] - 2026-02-28

### 修正
- `build()` 内の `MapboxOptions.setAccessToken` を `initState()` に移動（毎フレームの副作用を排除）
- `_initServices()` / `_loadPhotos()` の各 await 後に `mounted` チェックを追加（dispose 後の setState クラッシュ防止）
- `PhotoService.getMemoriesForDate` に try-catch を追加（写真 I/O 例外によるクラッシュ防止）
- `LocationService.startTracking()` の listen に `onError` ハンドラを追加（GPS 無効時の未処理エラー防止）
- `_getVisiblePhotos()` のゼロ除算リスクを修正し、O(n^2) を O(n) に改善
- 強制アンラップ `!` をローカル変数バインドに置換（null 安全性向上）

### 改善
- `onCameraChangeListener` に 100ms debounce を導入（パフォーマンス改善）
- `WebMapScreen` に `MapController.dispose()` を追加（メモリリーク防止）
- `photo_card.dart` の imageBytes をローカル変数バインドに変更
- `LocationService.getMockPath()` デッドコードを削除

## [1.0.0] - 2026-02-13

### 追加
- リアルタイムGPS軌跡描画（Mapbox Maps）
- 写真の自動マッピング（位置情報付き写真を地図上に配置）
- タイムラインスクラブ機能（スライダーで時系列再生）
- 「今日のふりかえり」AI風サマリー生成
- グラスモーフィズムUIデザイン
- Web版デモモード（OpenStreetMap + サンプルデータ）
- オンボーディング画面（初回起動時の権限説明）
- 設定画面（利用規約、プライバシーポリシー、OSSライセンス）
- プライバシーポリシー（日本語・英語）
- 利用規約

### 対応プラットフォーム
- iOS
- Android
- Web（デモモード）
- macOS
