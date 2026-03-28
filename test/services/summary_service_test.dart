import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trace_memories/services/summary_service.dart';

Position _pos(double lat, double lng) {
  return Position(
    latitude: lat,
    longitude: lng,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );
}

void main() {
  late SummaryService service;

  setUp(() {
    service = SummaryService();
  });

  group('generateSummary', () {
    test('空のパスと写真で白紙メッセージを返す', () {
      final result = service.generateSummary(path: [], photos: []);
      expect(result, contains('白紙のページ'));
    });

    test('短距離パス（<1000m）でメートル表示', () {
      // 渋谷駅付近の近距離2点（約100m）
      final path = [
        _pos(35.6580, 139.7016),
        _pos(35.6590, 139.7020),
      ];
      final result = service.generateSummary(path: path, photos: []);
      expect(result, contains('メートル'));
      expect(result, contains('今日の軌跡'));
    });

    test('中距離パス（1000-5000m）でkm表示', () {
      // 渋谷→原宿（約1.5km）
      final path = [
        _pos(35.6580, 139.7016),
        _pos(35.6710, 139.7010),
      ];
      final result = service.generateSummary(path: path, photos: []);
      expect(result, contains('km'));
      expect(result, contains('散策'));
    });

    test('長距離パス（>5000m）でkm表示', () {
      // 大きく離れた2点（約10km）
      final path = [
        _pos(35.6580, 139.7016),
        _pos(35.7580, 139.7016),
      ];
      final result = service.generateSummary(path: path, photos: []);
      expect(result, contains('km'));
      expect(result, contains('遠くまで'));
    });

    test('写真なしの場合のメッセージ', () {
      final path = [
        _pos(35.6580, 139.7016),
        _pos(35.6590, 139.7020),
      ];
      final result = service.generateSummary(path: path, photos: []);
      expect(result, contains('カメラは使わなかった'));
    });

    test('サマリーにおつかれさまメッセージが含まれる', () {
      final result = service.generateSummary(path: [_pos(35.0, 139.0)], photos: []);
      expect(result, contains('お疲れさま'));
    });
  });
}
