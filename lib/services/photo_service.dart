import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';

class PhotoMemory {
  final String id;
  final AssetEntity entity;
  final double? latitude;
  final double? longitude;
  final DateTime dateTime;
  final Uint8List? thumbnail;

  PhotoMemory({
    required this.id,
    required this.entity,
    this.latitude,
    this.longitude,
    required this.dateTime,
    this.thumbnail,
  });
}

class PhotoService {
  Future<bool> requestPermission() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtended();
    return ps.isAuth;
  }

  Future<List<PhotoMemory>> getMemoriesForDate(DateTime date) async {
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        orders: [
          const OrderOption(type: OrderOptionType.createDate, asc: false),
        ],
      ),
    );

    if (paths.isEmpty) return [];

    final List<AssetEntity> entities = await paths[0].getAssetListRange(
      start: 0,
      end: 100, // Fetch recent 100 images
    );

    List<PhotoMemory> memories = [];
    
    for (var entity in entities) {
      // Check if photo was taken on the specific date
      if (entity.createDateTime.year == date.year &&
          entity.createDateTime.month == date.month &&
          entity.createDateTime.day == date.day) {
        
        final latlng = await entity.latlngAsync();
        
        if (latlng.latitude != null && latlng.longitude != null) {
          final thumbnail = await entity.thumbnailDataWithSize(
            const ThumbnailSize(200, 200),
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
    }
    
    return memories;
  }
}
