import 'package:flutter_test/flutter_test.dart';
import 'package:trace_memories/services/location_service.dart';

void main() {
  late LocationService service;

  setUp(() {
    service = LocationService();
  });

  tearDown(() {
    service.dispose();
  });

  group('LocationService', () {
    test('初期状態でcurrentPathが空', () {
      expect(service.currentPath, isEmpty);
    });

    test('clearPath()がpathStreamに空リストを送る', () async {
      // pathStreamをリッスンしてから clearPath を呼ぶ
      final future = service.pathStream.first;
      service.clearPath();
      final result = await future;
      expect(result, isEmpty);
    });

    test('pathStreamがブロードキャストストリーム', () {
      // 複数リスナーが可能であること
      final sub1 = service.pathStream.listen((_) {});
      final sub2 = service.pathStream.listen((_) {});

      // エラーが発生しなければ成功
      sub1.cancel();
      sub2.cancel();
    });
  });
}
