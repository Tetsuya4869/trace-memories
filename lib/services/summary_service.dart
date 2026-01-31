import 'package:geolocator/geolocator.dart';
import 'photo_service.dart';

class SummaryService {
  String generateSummary({
    required List<Position> path,
    required List<PhotoMemory> photos,
  }) {
    if (path.isEmpty && photos.isEmpty) {
      return "今日はまだ冒険が始まっていないようです。さあ、外に出かけましょう！";
    }

    final distance = _calculateTotalDistance(path);
    final photoCount = photos.length;
    
    String summary = "【今日の旅の記録】\n\n";
    summary += "今日は約${(distance / 1000).toStringAsFixed(1)}kmの道のりを歩みました。";
    
    if (photoCount > 0) {
      summary += "その道中で、${photoCount}つの大切な思い出を形に残しましたね。\n\n";
      summary += "特に、${_getTimeOfDay(photos.first.dateTime)}に訪れた場所での一枚は、今日を象徴する素晴らしい記録です。";
    } else {
      summary += "写真は撮りませんでしたが、一歩一歩があなたの確かな軌跡として刻まれています。";
    }

    summary += "\n\nゆっくり休んで、また明日も素敵な足跡を残しましょう。✨";
    return summary;
  }

  double _calculateTotalDistance(List<Position> path) {
    double total = 0;
    for (int i = 0; i < path.length - 1; i++) {
      total += Geolocator.distanceBetween(
        path[i].latitude, path[i].longitude,
        path[i+1].latitude, path[i+1].longitude,
      );
    }
    return total;
  }

  String _getTimeOfDay(DateTime dt) {
    if (dt.hour < 12) return "午前中";
    if (dt.hour < 17) return "午後";
    return "夕暮れ時";
  }
}
