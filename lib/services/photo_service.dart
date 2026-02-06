import 'package:photo_manager/photo_manager.dart';
import '../models/photo_memory.dart';

export '../models/photo_memory.dart';

class PhotoService {
  static const int _maxPhotosPerQuery = 500;
  static const int _thumbnailSize = 200;

  Future<bool> requestPermission() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    return ps.isAuth;
  }

  Future<List<PhotoMemory>> getMemoriesForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        createTimeCond: DateTimeCond(
          min: startOfDay,
          max: endOfDay,
        ),
        orders: [
          const OrderOption(type: OrderOptionType.createDate, asc: false),
        ],
      ),
    );

    if (paths.isEmpty) return [];

    final List<AssetEntity> entities = await paths[0].getAssetListRange(
      start: 0,
      end: _maxPhotosPerQuery,
    );

    List<PhotoMemory> memories = [];

    for (var entity in entities) {
      final latlng = await entity.latlngAsync();

      if (latlng != null && latlng.latitude != 0 && latlng.longitude != 0) {
        final thumbnail = await entity.thumbnailDataWithSize(
          const ThumbnailSize(_thumbnailSize, _thumbnailSize),
        );

        memories.add(PhotoMemory(
          id: entity.id,
          entity: entity,
          latitude: latlng.latitude,
          longitude: latlng.longitude,
          dateTime: entity.createDateTime,
          thumbnail: thumbnail,
        ));
      }
    }

    return memories;
  }
}
