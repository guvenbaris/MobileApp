import '../../../core/result/result.dart';
import '../domain/lesson_repository.dart';

/// Sabit örnek içerik döndüren sahte ders deposu.
class FakeLessonRepository implements LessonRepository {
  FakeLessonRepository() {
    for (final path in _paths) {
      for (final (index, id) in path.lessonIds.indexed) {
        _lessons[id] = Lesson(
          id: id,
          pathId: path.id,
          order: index + 1,
          title: '${path.title} ${index + 1}',
          isFree: index < 3,
        );
      }
    }
  }

  static final List<LessonPath> _paths = [
    LessonPath(
      id: 'elif-ba',
      title: 'Elif-Ba',
      lessonIds: [for (var i = 1; i <= 30; i++) 'elif-ba-$i'],
    ),
    LessonPath(
      id: 'tecvid',
      title: 'Tecvid',
      lessonIds: [for (var i = 1; i <= 30; i++) 'tecvid-$i'],
    ),
  ];

  final Map<String, Lesson> _lessons = {};

  @override
  Future<Result<List<LessonPath>>> getPaths() async => Ok(_paths);

  @override
  Future<Result<Lesson>> getLesson(String lessonId) async {
    final lesson = _lessons[lessonId];
    return lesson == null
        ? Err(NotFoundFailure('Ders bulunamadı: $lessonId'))
        : Ok(lesson);
  }
}
