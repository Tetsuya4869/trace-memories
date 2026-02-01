import 'dart:typed_data';
import 'package:geolocator/geolocator.dart' as geo;

/// Web版デモ用のモックデータ
class DemoData {
  /// 渋谷〜原宿〜表参道を歩いた軌跡（デモ用）
  static List<geo.Position> get samplePath {
    final now = DateTime.now();
    final positions = <geo.Position>[];

    // 渋谷駅周辺から原宿方面への散歩ルート
    final route = [
      [139.7016, 35.6580], // 渋谷駅
      [139.7020, 35.6590],
      [139.7025, 35.6605],
      [139.7030, 35.6620],
      [139.7028, 35.6640], // 明治通り
      [139.7025, 35.6660],
      [139.7020, 35.6680],
      [139.7015, 35.6695],
      [139.7010, 35.6710], // 原宿駅付近
      [139.7005, 35.6720],
      [139.7000, 35.6725],
      [139.6990, 35.6715], // 表参道方面
      [139.6980, 35.6705],
      [139.6970, 35.6695],
      [139.6960, 35.6685],
      [139.6950, 35.6675], // 表参道
    ];

    for (var i = 0; i < route.length; i++) {
      positions.add(geo.Position(
        latitude: route[i][1],
        longitude: route[i][0],
        timestamp: now.subtract(Duration(minutes: (route.length - i) * 5)),
        accuracy: 10.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 1.2,
        speedAccuracy: 0.0,
      ));
    }

    return positions;
  }

  /// デモ用の写真メモリー
  static List<DemoPhotoMemory> get samplePhotos {
    final now = DateTime.now();
    return [
      DemoPhotoMemory(
        id: '1',
        latitude: 35.6590,
        longitude: 139.7020,
        dateTime: now.subtract(const Duration(hours: 2, minutes: 30)),
        label: '渋谷スクランブル交差点',
      ),
      DemoPhotoMemory(
        id: '2',
        latitude: 35.6710,
        longitude: 139.7010,
        dateTime: now.subtract(const Duration(hours: 1, minutes: 45)),
        label: '原宿駅前',
      ),
      DemoPhotoMemory(
        id: '3',
        latitude: 35.6675,
        longitude: 139.6950,
        dateTime: now.subtract(const Duration(hours: 1)),
        label: '表参道のカフェ',
      ),
    ];
  }

  /// デモ用のプレースホルダー画像を生成
  static Uint8List generatePlaceholderImage(int index) {
    // 1x1 ピクセルの透明PNG（実際の表示ではアイコンで代替）
    return Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
      0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
      0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
      0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
      0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
      0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
      0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
      0x42, 0x60, 0x82,
    ]);
  }
}

/// デモ用の写真メモリークラス
class DemoPhotoMemory {
  final String id;
  final double latitude;
  final double longitude;
  final DateTime dateTime;
  final String label;

  DemoPhotoMemory({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.dateTime,
    required this.label,
  });
}
