import 'package:flutter_test/flutter_test.dart';
import 'package:trace_memories/services/summary_service.dart';
import 'package:trace_memories/services/demo_data.dart';

void main() {
  group('SummaryService', () {
    late SummaryService service;

    setUp(() {
      service = SummaryService();
    });

    test('generates empty-day summary when no path and no photos', () {
      final summary = service.generateSummary(path: [], photos: []);
      expect(summary, contains('白紙のページ'));
    });

    test('generates short distance summary under 1km', () {
      final path = DemoData.samplePath.take(2).toList();
      final summary = service.generateSummary(path: path, photos: []);
      expect(summary, contains('メートル'));
      expect(summary, contains('今日の軌跡'));
    });

    test('generates summary with no photos message', () {
      final path = DemoData.samplePath.take(3).toList();
      final summary = service.generateSummary(path: path, photos: []);
      expect(summary, contains('カメラは使わなかった'));
    });

    test('generates closing message', () {
      final summary = service.generateSummary(path: [], photos: []);
      expect(summary, contains('踏み出しましょう'));
    });
  });

  group('DemoData', () {
    test('samplePath returns non-empty list of positions', () {
      final path = DemoData.samplePath;
      expect(path, isNotEmpty);
      expect(path.length, greaterThan(2));
    });

    test('samplePath positions have valid coordinates', () {
      for (final pos in DemoData.samplePath) {
        expect(pos.latitude, inInclusiveRange(-90, 90));
        expect(pos.longitude, inInclusiveRange(-180, 180));
      }
    });

    test('samplePhotos returns non-empty list', () {
      final photos = DemoData.samplePhotos;
      expect(photos, isNotEmpty);
    });

    test('samplePhotos have valid coordinates', () {
      for (final photo in DemoData.samplePhotos) {
        expect(photo.latitude, inInclusiveRange(-90, 90));
        expect(photo.longitude, inInclusiveRange(-180, 180));
      }
    });

    test('generatePlaceholderImage returns valid PNG bytes', () {
      final bytes = DemoData.generatePlaceholderImage(0);
      expect(bytes, isNotEmpty);
      // PNG magic bytes
      expect(bytes[0], 0x89);
      expect(bytes[1], 0x50); // P
      expect(bytes[2], 0x4E); // N
      expect(bytes[3], 0x47); // G
    });
  });
}
