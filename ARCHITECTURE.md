# アーキテクチャ概要

## 全体構成

```
┌─────────────────────────────────────────────┐
│                  main.dart                   │
│         OnboardingGate (kIsWeb分岐)          │
├──────────────────┬──────────────────────────┤
│   MapScreen      │    WebMapScreen           │
│  (ネイティブ版)    │   (Web デモモード)          │
│  Mapbox SDK      │   flutter_map + OSM      │
├──────────────────┴──────────────────────────┤
│                 Services                     │
│  LocationService │ PhotoService │ SummaryService │
├──────────────────────────────────────────────┤
│                  Widgets                     │
│  GlassContainer │ PhotoCard │ TimelineBar    │
│  SummaryDialog                               │
├──────────────────────────────────────────────┤
│               Theme (AppTheme)               │
└──────────────────────────────────────────────┘
```

## プラットフォーム分岐

`kIsWeb` によってアプリの動作が切り替わります。

| | ネイティブ版 (iOS/Android/macOS) | Web 版 |
|---|---|---|
| 地図 SDK | mapbox_maps_flutter | flutter_map + OpenStreetMap |
| 位置情報 | Geolocator (リアルタイム GPS) | DemoData (サンプル軌跡) |
| 写真 | photo_manager (端末ライブラリ) | DemoData (サンプル写真) |
| 環境変数 | `.env` (Mapbox Token 必須) | 不要 |
| 画面 | MapScreen | WebMapScreen |

分岐ポイント: `lib/main.dart`

```dart
home: kIsWeb ? const WebMapScreen() : const OnboardingGate(),
```

## レイヤー構成

### 1. Screens (画面)

各画面は `StatefulWidget` で構成されています。

| 画面 | ファイル | 責務 |
|------|---------|------|
| MapScreen | `screens/map_screen.dart` | ネイティブ地図表示、軌跡描画、写真カード配置 |
| WebMapScreen | `screens/web_map_screen.dart` | Web 地図表示（デモデータ使用） |
| OnboardingScreen | `screens/onboarding_screen.dart` | 初回起動時の権限説明 |
| SettingsScreen | `screens/settings_screen.dart` | アプリ設定、利用規約、プライバシーポリシー |

### 2. Services (ビジネスロジック)

画面から呼び出される非 UI ロジックです。

| サービス | ファイル | 責務 |
|---------|---------|------|
| LocationService | `services/location_service.dart` | GPS ストリーム管理、権限チェック |
| PhotoService | `services/photo_service.dart` | 写真ライブラリアクセス、位置情報付き写真のフィルタリング |
| SummaryService | `services/summary_service.dart` | 一日のサマリーテキスト生成（距離、写真枚数） |
| DemoData | `services/demo_data.dart` | Web デモ用サンプルデータ |

### 3. Widgets (UI コンポーネント)

再利用可能な UI 部品です。

| ウィジェット | ファイル | 責務 |
|------------|---------|------|
| GlassContainer | `widgets/glass_container.dart` | グラスモーフィズムコンテナ |
| PhotoCard | `widgets/photo_card.dart` | 写真サムネイルカード（地図上に表示） |
| TimelineBar | `widgets/timeline_bar.dart` | タイムラインスライダー |
| SummaryDialog | `widgets/summary_dialog.dart` | サマリー表示ダイアログ |

### 4. Theme (デザインシステム)

`lib/theme/app_theme.dart` にすべてのデザイントークンを集約しています。

- 色定数 (`primaryDark`, `accentBlue`, etc.)
- グラスモーフィズム設定 (`glassBackground`, `glassBorder`, `glassBlur`)
- グラデーション (`routeGradient`, `glassGradient`)
- テーマデータ (`darkTheme`)
- Box デコレーション (`glassDecoration`, `photoCardDecoration`)

## データフロー

### 位置情報の流れ (ネイティブ版)

```
Geolocator.getPositionStream()
    ↓
LocationService._positionStreamSubscription
    ↓ (listen)
LocationService._path に蓄積
    ↓
LocationService._controller.add(path)
    ↓ (StreamController.broadcast)
MapScreen._pathSubscription
    ↓ (listen)
setState(() => _currentPath = path)
    ↓
_updateRouteLayer() → PolylineAnnotationManager
```

### 写真の流れ (ネイティブ版)

```
PhotoManager.getAssetPathList()
    ↓
PhotoService.getMemoriesForDate()
    ↓ (日付フィルタ + 位置情報フィルタ)
List<PhotoMemory>
    ↓
MapScreen._photoMemories
    ↓
_buildPhotoCards() → pixelForCoordinate() → Positioned + PhotoCard
```

### タイムライン操作

```
TimelineBar.onProgressChanged(value)
    ↓
MapScreen._timelineProgress = value
    ↓
_updateRouteLayer()  → 軌跡の表示範囲を更新
_buildPhotoCards()   → 写真カードの表示数を更新
```

## 状態管理

現在は `StatefulWidget` + `setState` によるローカル状態管理を採用しています。

### MapScreen の主要ステート

| 変数 | 型 | 説明 |
|------|---|------|
| `_mapboxMap` | `MapboxMap?` | Mapbox 地図インスタンス |
| `_currentPath` | `List<Position>` | GPS 軌跡データ |
| `_photoMemories` | `List<PhotoMemory>` | 位置情報付き写真のリスト |
| `_timelineProgress` | `double` | タイムラインの進行度 (0.0 - 1.0) |
| `_isLoadingPhotos` | `bool` | 写真読み込み中フラグ |
| `_hasLocationPermission` | `bool` | 位置情報権限の状態 |
| `_hasPhotoPermission` | `bool` | 写真権限の状態 |

## 既知のアーキテクチャ課題

1. **データ永続化が未実装**: 軌跡・写真・サマリーはメモリ上のみで保持。アプリ再起動で消失。
2. **オンボーディング状態が非永続**: 毎回起動時に表示される。SharedPreferences で永続化が必要。
3. **FutureBuilder の再生成**: `_buildPhotoCards()` 内で毎 build ごとに新しい Future を生成している。
4. **状態管理の集約**: 画面が複雑化した場合、Provider / Riverpod への移行を検討。
