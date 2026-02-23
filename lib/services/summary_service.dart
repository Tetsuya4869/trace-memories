import 'package:geolocator/geolocator.dart';
import 'photo_service.dart';

class SummaryService {
  String generateSummary({
    required List<Position> path,
    required List<PhotoMemory> photos,
  }) {
    if (path.isEmpty && photos.isEmpty) {
      return "今日の物語は、まだ白紙のページ。\n\n窓の外には、あなたを待つ景色が広がっています。さあ、新しい一歩を踏み出しましょう。";
    }

    final distance = _calculateTotalDistance(path);
    final photoCount = photos.length;

    String summary = "✦ 今日の軌跡 ✦\n\n";

    if (distance < 1000) {
      summary += "${distance.toStringAsFixed(0)}メートル——ささやかな距離に見えて、確かな一歩でした。";
    } else if (distance < 5000) {
      summary += "${(distance / 1000).toStringAsFixed(1)}km——街を散策するには、ちょうどいい距離ですね。";
    } else {
      summary += "${(distance / 1000).toStringAsFixed(1)}km——今日は少し遠くまで足を延ばしましたね。";
    }

    if (photoCount > 0) {
      summary += "\n\nその道の途中で、$photoCountつの瞬間を永遠に閉じ込めました。";
      if (photoCount == 1) {
        summary += "\n\n${_getTimeOfDay(photos.first.dateTime)}、ふと立ち止まってシャッターを切った——きっと、心が動いた瞬間があったのでしょう。";
      } else {
        summary += "\n\n${_getTimeOfDay(photos.first.dateTime)}から始まった今日の記録。どの一枚にも、あなただけの物語が宿っています。";
      }
    } else {
      summary += "\n\nカメラは使わなかったけれど、あなたの目に映った風景は、きっと心に残っているはず。";
    }

    summary += "\n\n今日もお疲れさまでした。\nあなたの足跡が、明日への道しるべになりますように ✨";
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
    if (dt.hour < 6) return "まだ夜が明けきらぬ頃";
    if (dt.hour < 10) return "朝の澄んだ空気の中";
    if (dt.hour < 12) return "陽が高く昇る頃";
    if (dt.hour < 15) return "午後のひととき";
    if (dt.hour < 18) return "夕暮れの柔らかな光の中";
    return "夜の帳が降りる頃";
  }
}
