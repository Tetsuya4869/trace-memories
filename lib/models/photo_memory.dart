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
