import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/flavor.dart';
import '../../../core/config/flavor_provider.dart';
import '../data/fake_lesson_repository.dart';
import '../domain/lesson_repository.dart';

final lessonRepositoryProvider = Provider<LessonRepository>(
  (ref) => switch (ref.watch(flavorProvider)) {
    Flavor.dev => FakeLessonRepository(),
    Flavor.prod => throw UnimplementedError(
      'Gerçek LessonRepository Faz 4\'te eklenecek (M9)',
    ),
  },
);
