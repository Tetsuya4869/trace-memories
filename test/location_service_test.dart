import 'package:flutter_test/flutter_test.dart';
import 'package:trace_memories/services/location_service.dart';

void main() {
  group('LocationService', () {
    late LocationService service;

    setUp(() {
      service = LocationService();
    });

    tearDown(() {
      service.dispose();
    });

    test('initial currentPath is empty', () {
      expect(service.currentPath, isEmpty);
    });

    test('getMockPath returns non-empty list', () {
      final mockPath = service.getMockPath();
      expect(mockPath, isNotEmpty);
      expect(mockPath.length, 3);
    });

    test('getMockPath positions have valid coordinates', () {
      final mockPath = service.getMockPath();
      for (final pos in mockPath) {
        expect(pos.latitude, inInclusiveRange(-90, 90));
        expect(pos.longitude, inInclusiveRange(-180, 180));
      }
    });

    test('clearPath resets path to empty', () async {
      service.clearPath();
      expect(service.currentPath, isEmpty);
    });

    test('pathStream emits empty list after clearPath', () async {
      service.pathStream.listen(expectAsync1((path) {
        expect(path, isEmpty);
      }));
      service.clearPath();
    });

    test('dispose can be called safely', () {
      // Should not throw
      service.dispose();
    });
  });
}
