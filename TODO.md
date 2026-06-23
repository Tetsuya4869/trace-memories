# TODO — TraceMemories 改善リスト

コードベース分析に基づく改善項目。優先度順に整理。

---

## 高優先度（バグ・品質問題） — 全て完了

### 1. テストファイルの修正 [完了]
- `test/widget_test.dart` をFlutterテンプレートから `SummaryService` と `DemoData` のテストに書き換え
- `test/location_service_test.dart` を新規作成

### 2. LocationServiceのリソースリーク修正 [完了]
- `dispose()` メソッドを追加、`stopTracking()` と `_controller.close()` を実行

### 3. MapScreenのdisposeクリーンアップ [完了]
- `_pathSubscription` をフィールドに保持し、`dispose()` で解除
- `_locationService.dispose()` を呼び出し

---

## 中優先度（コード品質・設計改善） — 全て完了

### 4. PhotoMemoryモデルの分離 [完了]
- `lib/models/photo_memory.dart` に分離
- `photo_service.dart` から `export` でアクセス維持

### 5. 未使用パッケージの削除 [完了]
- `provider` を `pubspec.yaml` から削除

### 6. 写真取得のページネーション改善 [完了]
- `DateTimeCond` で日付範囲フィルタを追加、上限を500に拡張
- マジックナンバーを `_maxPhotosPerQuery`, `_thumbnailSize` 定数に

### 7. _onMapCreatedの戻り値型の明示 [完了]
- `MapRouteController.onMapCreated` として移動・型注釈済み

---

## 低優先度（将来の改善） — 全て完了

### 8. Serviceのユニットテスト追加 [完了]
- `test/widget_test.dart`: SummaryService 4件 + DemoData 5件
- `test/location_service_test.dart`: LocationService 6件

### 9. エラーハンドリングの強化 [完了]
- パーミッション拒否時に SnackBar でガイダンスを表示

### 10. MapScreenの責務分離 [完了]
- `lib/services/map_route_controller.dart` に地図制御ロジックを抽出
- ルート描画、カメラ操作、座標変換を `MapRouteController` に集約

### 11. 定数のマジックナンバー排除 [完了]
- `LocationService._distanceFilterMeters`
- `PhotoService._maxPhotosPerQuery`, `_thumbnailSize`
- `MapRouteController._routeLineWidth`, `_overviewZoom`, `_focusZoom`, `_cameraPitch`, `_flyToDurationMs`
- `_MapScreenState._offScreenMargin`, `_cardOffsetX`, `_cardOffsetY`
- `withOpacity` → `withValues(alpha:)` に統一

---

## 全体見直し（バグ修正・機能改善） — 完了

### 13. クリティカルなバグ修正 [完了]
- TimelineBar: ハンドル位置・ドラッグ計算を `LayoutBuilder` の実幅ベースに修正、タップ操作対応
- 写真フィルタ: `(idx + 1) / length` でタイムライン連動を正常化（Native/Web両画面）
- `MapboxOptions.setAccessToken` を `build()` → `initState()` へ移動
- async境界での `mounted` チェック強化
- `MapRouteController` の null安全性向上（強制アンラップ除去、`whenReady()` 追加）

### 14. タイムライン再生機能 [完了]
- `AnimationController` で進捗を 0.0→1.0 に自動駆動（再生時間8秒）
- TimelineBar に再生/停止ボタンを追加（プレゼンテーション専用は維持）
- 手動ドラッグ時は再生を自動停止
- Native (`MapScreen`) / Web (`WebMapScreen`) 両対応

---

## 未対応（ロードマップ機能）

### 15. ロードマップ機能の実装
- [ ] クラウド同期 (Firebase)
- [ ] 思い出の動画書き出し
- [ ] 日付選択（過去の日の軌跡を表示）

---

更新日: 2026-06-23
