# TODO — TraceMemories 改善リスト

コードベース分析に基づく改善項目。優先度順に整理。

---

## 高優先度（バグ・品質問題）

### 1. テストファイルの修正
- **場所:** `test/widget_test.dart`
- **問題:** Flutterテンプレートのまま `MyApp` を参照しているが、実際のアプリは `TraceMemoriesApp`。テスト実行時にコンパイルエラーになる。
- **対応:** テンプレートを削除し、`TraceMemoriesApp` のスモークテストに書き換える。最低限、アプリが起動してクラッシュしないことを確認するテストを作成。

### 2. LocationServiceのリソースリーク修正
- **場所:** `lib/services/location_service.dart`
- **問題:** `StreamController` の `close()` や購読の `cancel()` を行う `dispose()` メソッドが存在しない。メモリリーク・リソースリークの原因になる。
- **対応:** `dispose()` メソッドを追加し、`MapScreen` の `dispose()` から呼び出す。

### 3. MapScreenのdisposeでのクリーンアップ不足
- **場所:** `lib/screens/map_screen.dart`
- **問題:** `_MapScreenState` に `dispose()` のオーバーライドがない。`LocationService` のStream購読やトラッキングが画面破棄後も動き続ける可能性がある。
- **対応:** `dispose()` を追加して `_locationService.stopTracking()` と Stream購読の解除を行う。

---

## 中優先度（コード品質・設計改善）

### 4. PhotoMemoryモデルの分離
- **場所:** `lib/services/photo_service.dart` 内の `PhotoMemory` クラス
- **問題:** データモデルがServiceファイル内で定義されている。`DEVELOPMENT_RULES.md` で規定された `lib/models/` ディレクトリの方針と不一致。
- **対応:** `lib/models/photo_memory.dart` に分離し、`photo_service.dart` と `map_screen.dart` からインポートするよう変更。

### 5. 未使用パッケージの削除
- **場所:** `pubspec.yaml`
- **問題:** `provider` パッケージが依存関係にあるが、コード内で一切使用されていない。不要な依存はビルドサイズと複雑性を増す。
- **対応:** `provider` を `pubspec.yaml` から削除して `flutter pub get` を実行。

### 6. 写真取得のページネーション改善
- **場所:** `lib/services/photo_service.dart:40`
- **問題:** 先頭100件を取得してから日付フィルタリングを行うため、当日の写真が100件目以降にある場合は取得できない。
- **対応:** FilterOptionGroupに日付範囲フィルタを追加し、当日の写真のみを効率的に取得するよう改善。

### 7. _onMapCreatedの戻り値型の明示
- **場所:** `lib/screens/map_screen.dart:100`
- **問題:** `_onMapCreated` メソッドに戻り値の型注釈がない (`void` が省略されている)。
- **対応:** `void _onMapCreated(MapboxMap mapboxMap)` に修正。

---

## 低優先度（将来の改善）

### 8. Serviceのユニットテスト追加
- **対象:** `SummaryService`, `LocationService`, `PhotoService`
- **内容:**
  - `SummaryService`: 距離・写真数に応じたサマリー生成テスト
  - `LocationService`: モックパスの距離計算テスト
  - `PhotoService`: 日付フィルタリングロジックのテスト（モック使用）

### 9. エラーハンドリングの強化
- **場所:** `lib/screens/map_screen.dart:41-56`
- **問題:** パーミッション拒否時にユーザーへのフィードバックがない。`_initServices()` で権限がなくてもUIに何も表示されない。
- **対応:** パーミッション拒否時にSnackBarやダイアログでガイダンスを表示。

### 10. MapScreenの責務分離
- **場所:** `lib/screens/map_screen.dart`
- **問題:** 258行あり、地図制御・写真表示・タイムライン・サマリーなど多くの責務を持つ。
- **対応:** 将来の機能追加に備え、地図コントローラーロジックを別クラスに抽出することを検討。

### 11. 定数のマジックナンバー排除
- **場所:** 複数ファイル
- **例:**
  - `photo_service.dart:41` — `end: 100` (写真取得上限)
  - `photo_service.dart:55` — `ThumbnailSize(200, 200)` (サムネイルサイズ)
  - `location_service.dart:33` — `distanceFilter: 10` (距離フィルタ)
  - `map_screen.dart:156-157` — `100` (画面外判定マージン)
- **対応:** 定数として命名・定義し、意図を明確にする。

### 12. ロードマップ機能の実装
- **README.mdのロードマップより:**
  - [ ] クラウド同期 (Firebase)
  - [ ] 思い出の動画書き出し

---

作成日: 2026-02-06
