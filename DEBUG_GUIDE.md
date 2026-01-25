# TraceMemories 究極の開発・デバッグガイド 🛰️🛠️

このドキュメントでは、TraceMemoriesの開発環境の構築から、高度なデバッグ手法、トラブルシューティングまでを詳細に解説します。

---

## 1. 開発環境のセットアップ (Perfect Setup)

### 推奨エディタ: VS Code
以下の拡張機能をインストールすることで、開発効率が劇的に向上します。
- **Dart & Flutter**: 必須。コード補完とデバッグ。
- **Error Lens**: エラーをインラインで表示。
- **Mapbox Maps Helper**: 地図スタイルのプレビューに便利。

### 依存関係のクリーンアップ
不具合を感じたら、まずこの「三種の神器」を実行してください。
```bash
flutter clean
flutter pub get
```

---

## 2. 高度なデバッグ手法 (Mastering Debug)

### ⚡️ Hot Reload & Hot Restart
- **Hot Reload (r)**: UIの微調整に。状態を維持したまま数秒で反映。
- **Hot Restart (R)**: `initState` やグローバル変数を書き換えたときに使用。

### 🛠 Flutter DevTools
アプリ実行中にターミナルに表示されるURL、またはVS Codeのステータスバーから起動できます。
- **Widget Inspector**: グラスモーフィズムのレイヤー重なり（Stack）を確認するのに最適。
- **Network Tab**: Mapboxのタイル読み込み状況を確認。

### 📡 位置情報のシミュレーション (Location Mocking)
実機を持って外に出なくてもデバッグ可能です。
- **Android**: `Location Settings` > `Mock location app` でGPSシミュレーターを使用。
- **iOS**: Simulatorの `Features` > `Location` > `City Run` などを選択。
- **コード側**: `LocationService` に用意した `getMockPath()` を使って擬似的な軌跡を描画できます。

---

## 3. トラブルシューティング (Troubleshooting)

### ❌ Mapboxが真っ白になる
- **原因**: Public Tokenの設定漏れ、またはSecret Tokenの権限不足。
- **対策**: `.env` に正しい `pk.` トークンがあるか確認。また、Secret Token作成時に `DOWNLOADS:READ` スコープが付与されているか再確認してください。

### ❌ ビルドエラー (Android)
- **原因**: `gradle.properties` にSecret Tokenがない。
- **対策**: `android/gradle.properties` に `MAPBOX_DOWNLOADS_TOKEN=sk....` が記述されているか確認してください。

### ❌ 位置情報が取れない
- **原因**: 権限の未許可。
- **対策**: 設定アプリからアプリの権限を手動で「常に許可」に変更してみてください。

---

## 4. UI/UX の微調整 (Design Debug)

グラスモーフィズムの透明度やボカシ（Blur）を調整したい場合は、`lib/theme/app_theme.dart` 内の定数を書き換えるだけで、アプリ全体の雰囲気を一括変更できます。

- `AppTheme.glassBlur`: ボカシの強さ
- `AppTheme.glassBackground`: 背景の透明度

---

Happy Debugging! 🚀
