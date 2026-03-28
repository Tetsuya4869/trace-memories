import 'package:flutter_test/flutter_test.dart';
import 'package:trace_memories/services/demo_data.dart';

void main() {
  group('DemoData', () {
    group('samplePath', () {
      test('非空のリストを返す', () {
        final path = DemoData.samplePath;
        expect(path, isNotEmpty);
      });

      test('16件のポジションを返す', () {
        final path = DemoData.samplePath;
        expect(path.length, 16);
      });

      test('全座標が有効な範囲内', () {
        for (final pos in DemoData.samplePath) {
          expect(pos.latitude, inInclusiveRange(-90.0, 90.0));
          expect(pos.longitude, inInclusiveRange(-180.0, 180.0));
        }
      });

      test('座標が東京エリア内', () {
        for (final pos in DemoData.samplePath) {
          expect(pos.latitude, inInclusiveRange(35.0, 36.0));
          expect(pos.longitude, inInclusiveRange(139.0, 140.0));
        }
      });
    });

    group('samplePhotos', () {
      test('3件の写真を返す', () {
        final photos = DemoData.samplePhotos;
        expect(photos.length, 3);
      });

      test('各写真にラベルがある', () {
        for (final photo in DemoData.samplePhotos) {
          expect(photo.label, isNotEmpty);
        }
      });

      test('各写真にIDがある', () {
        for (final photo in DemoData.samplePhotos) {
          expect(photo.id, isNotEmpty);
        }
      });

      test('全座標が有効な範囲内', () {
        for (final photo in DemoData.samplePhotos) {
          expect(photo.latitude, inInclusiveRange(-90.0, 90.0));
          expect(photo.longitude, inInclusiveRange(-180.0, 180.0));
        }
      });
    });

    group('generatePlaceholderImage', () {
      test('有効なPNGバイナリを返す', () {
        final bytes = DemoData.generatePlaceholderImage(0);
        expect(bytes, isNotEmpty);
        // PNGマジックバイト
        expect(bytes[0], 0x89);
        expect(bytes[1], 0x50); // P
        expect(bytes[2], 0x4E); // N
        expect(bytes[3], 0x47); // G
      });

      test('異なるインデックスでも有効なデータを返す', () {
        final bytes1 = DemoData.generatePlaceholderImage(0);
        final bytes2 = DemoData.generatePlaceholderImage(1);
        expect(bytes1, isNotEmpty);
        expect(bytes2, isNotEmpty);
      });
    });
  });
}
