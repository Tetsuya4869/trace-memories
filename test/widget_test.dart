import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trace_memories/services/summary_service.dart';

void main() {
  group('SummaryService', () {
    late SummaryService service;

    setUp(() {
      service = SummaryService();
    });

    test('空のパスと写真で白紙メッセージを返す', () {
      final result = service.generateSummary(path: [], photos: []);
      expect(result, contains('白紙のページ'));
    });

    test('短距離パスでメートル表示', () {
      final path = [
        Position(latitude: 35.6580, longitude: 139.7016, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0),
        Position(latitude: 35.6590, longitude: 139.7020, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0),
      ];
      final result = service.generateSummary(path: path, photos: []);
      expect(result, contains('メートル'));
    });

    test('長距離パスでkm表示', () {
      final path = [
        Position(latitude: 35.6580, longitude: 139.7016, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0),
        Position(latitude: 35.7000, longitude: 139.7500, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0),
      ];
      final result = service.generateSummary(path: path, photos: []);
      expect(result, contains('km'));
    });
  });

  group('距離計算', () {
    test('同じ地点間の距離は0', () {
      final distance = Geolocator.distanceBetween(35.6580, 139.7016, 35.6580, 139.7016);
      expect(distance, equals(0.0));
    });

    test('異なる地点間の距離は正の値', () {
      final distance = Geolocator.distanceBetween(35.6580, 139.7016, 35.6710, 139.7010);
      expect(distance, greaterThan(0));
      // 渋谷→原宿は約1.4km
      expect(distance, greaterThan(1000));
      expect(distance, lessThan(2000));
    });
  });
}
