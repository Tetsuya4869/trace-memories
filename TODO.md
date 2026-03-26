# TraceMemories リリース TODO

## 完了済み

- [x] コンパイルエラー修正（glassGradient, Path衝突, .envアセット）
- [x] LocationService / MapScreen の dispose 処理
- [x] 権限拒否時のUIフィードバック（バナー表示）
- [x] .env 読み込みエラーハンドリング
- [x] オンボーディング画面（3ページ）
- [x] 設定画面（バージョン、利用規約、プライバシーポリシー、OSSライセンス、問い合わせ）
- [x] 利用規約の作成（アプリ内表示）
- [x] プライバシーポリシー修正（AdMob削除、プレースホルダー修正）
- [x] deprecated API 修正（withOpacity → withValues, .value → .toARGB32()）
- [x] タイムラインバーの操作改善（LayoutBuilder で正確な位置計算）
- [x] CHANGELOG 作成
- [x] ユニットテスト（SummaryService, 距離計算: 5件）
- [x] flutter analyze エラー0件
- [x] flutter test 全件パス

## データ永続化（リリース前に必須）

- [ ] SQLite でのローカル保存（sqflite は依存に含まれるが未使用）
  - [ ] daily_tracks テーブル: 日ごとのGPS軌跡を保存
  - [ ] photo_memories テーブル: 写真メモリーのキャッシュ
  - [ ] summaries テーブル: 生成したサマリーを保存
- [ ] SharedPreferences でオンボーディング完了フラグを永続化
- [ ] 過去の日付の軌跡を閲覧できるUI

## TestFlight リリース

- [ ] Apple Developer Program に登録（$99/年、審査に最大48時間）
- [ ] Mapbox iOS 認証設定（~/.netrc に Secret Token を設定）
  ```
  machine api.mapbox.com
  login mapbox
  password sk.YOUR_SECRET_TOKEN
  ```
- [ ] Xcode で署名設定（Runner → Signing & Capabilities → Team 選択）
- [ ] `cd ios && pod install`
- [ ] `flutter build ipa --release`
- [ ] Transporter アプリで App Store Connect にアップロード
- [ ] App Store Connect → TestFlight → テスト開始

## ストア正式リリース（将来）

- [ ] Android リリース署名キーの作成（build.gradle.kts の release 設定変更）
- [ ] ストアメタデータ（説明文、スクリーンショット、カテゴリ）
- [ ] メールアドレスを正式なものに差し替え（現在: support@tracememories.app）
- [ ] エラー監視ツール導入（Firebase Crashlytics or Sentry）
- [ ] CI/CD パイプライン構築（GitHub Actions）

## 将来の機能（ロードマップ）

- [ ] クラウド同期（Firebase Firestore）
- [ ] 思い出の動画書き出し
- [ ] 多言語対応（flutter_localizations）
- [ ] アクセシビリティ対応（Semantics ウィジェット）
