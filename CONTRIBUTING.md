# コントリビューションガイド

TraceMemories へのコントリビューションを検討いただきありがとうございます。

## 開発環境のセットアップ

### 前提条件

- Flutter SDK 3.x 以上
- Dart SDK 3.x 以上
- Xcode（iOS 開発時）/ Android Studio（Android 開発時）
- VS Code（推奨エディタ）

### 初期セットアップ

```bash
git clone https://github.com/your-username/trace-memories.git
cd trace-memories
flutter pub get
```

### ネイティブ版の場合

プロジェクトルートに `.env` ファイルを作成:

```env
MAPBOX_PUBLIC_TOKEN=pk.your_public_token
MAPBOX_SECRET_TOKEN=sk.your_secret_token
```

### 動作確認

```bash
flutter analyze   # エラー0件であること
flutter test      # 全件パスであること
```

## ブランチの作成

```bash
# 機能追加
git checkout -b feature/your-feature-name

# バグ修正
git checkout -b fix/your-fix-name
```

## コーディング規約

### 必須

- `AppTheme` の定数を使い、色やサイズをハードコードしない
- `GlassContainer` ウィジェットを再利用する
- `kIsWeb` でプラットフォーム分岐を行う
- `withOpacity()` ではなく `withValues(alpha:)` を使う
- `!` 強制アンラップは避け、ローカル変数にバインドしてから使う
- `build()` 内で副作用（SDK 初期化、API 呼び出し等）を実行しない
- async gap の後に `if (!mounted) return;` を挿入する
- I/O 操作には try-catch を付ける
- Stream の `listen` には `onError` を付ける
- Controller/Timer は `dispose()` で確実に破棄する

### 禁止

- `.env` を `pubspec.yaml` の assets に追加しない
- `StreamController` / `StreamSubscription` を dispose せずに放置しない
- `print()` をリリースコードに残さない

## コミットメッセージ

絵文字プレフィックスを使用:

| プレフィックス | 用途 |
|--------------|------|
| `✨ feat:` | 機能追加 |
| `🐛 fix:` | バグ修正 |
| `♻️ refactor:` | リファクタリング |
| `📝 docs:` | ドキュメント |
| `🧪 test:` | テスト |
| `🎨 style:` | コードスタイル |
| `⚡ perf:` | パフォーマンス改善 |

例:
```
✨ feat: タイムライン日付選択機能を追加
🐛 fix: 写真カードのゼロ除算エラーを修正
```

## PR の作成手順

1. 作業ブランチで変更をコミット
2. 以下のチェックをすべて通過させる:
   - `flutter analyze` — エラー0件
   - `flutter test` — 全件パス
3. PR を作成し、変更内容を説明
4. レビュー後にマージ

## テスト

### テストの実行

```bash
flutter test
```

### テストの追加方針

- `test/widget_test.dart` にユニットテストを追加
- 純粋な関数（SummaryService、距離計算など）は必ずテストを書く
- 新機能を追加する際は対応するテストも追加する

## ディレクトリ構成

新しいファイルを追加する際は、以下の構成に従ってください:

| ディレクトリ | 配置するもの |
|-------------|------------|
| `lib/screens/` | 画面単位のウィジェット |
| `lib/widgets/` | 再利用可能な UI コンポーネント |
| `lib/services/` | ビジネスロジック（位置情報、写真、DB 等） |
| `lib/theme/` | デザインシステム定義 |
| `test/` | ユニットテスト |

## 質問・相談

実装方針に迷った場合は、Issue を作成して相談してください。
