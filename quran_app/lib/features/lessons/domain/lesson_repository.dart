import '../../../core/result/result.dart';

/// Bir ders yolu (ör. "Elif-Ba", "Tecvid") (M9).
class LessonPath {
  const LessonPath({
    required this.id,
    required this.title,
    required this.lessonIds,
  });

  final String id;
  final String title;
  final List<String> lessonIds;
}

class Lesson {
  const Lesson({
    required this.id,
    required this.pathId,
    required this.order,
    required this.title,
    required this.isFree,
  });

  final String id;
  final String pathId;

  /// Yol içindeki sırası (1'den başlar).
  final int order;
  final String title;

  /// Abonelik olmadan açılabilen ders mi.
  final bool isFree;
}

/// Günlük eğitim içeriğine erişim (M9, v1.1). İçerik sunucudan gelir (M15).
abstract interface class LessonRepository {
  Future<Result<List<LessonPath>>> getPaths();

  Future<Result<Lesson>> getLesson(String lessonId);
}
