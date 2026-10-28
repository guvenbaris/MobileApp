import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran/data/drift_quran_repository.dart';
import 'package:quran_app/features/quran/domain/quran_models.dart';
import 'package:quran_app/features/reader/application/reader_providers.dart';

import '../../helpers/content_db.dart';

void main() {
  late AyahIndex index;

  setUp(() async {
    final repo = DriftQuranRepository(openTestContentDatabase());
    index = AyahIndex((await repo.getSurahs()).valueOrNull!);
  });

  test('6.236 ayetin hepsi sıra ↔ sure:ayet arasında birebir dönüşür', () {
    expect(index.length, 6236);
    for (var i = 0; i < index.length; i++) {
      expect(index.indexOf(index.refAt(i)), i);
    }
  });

  test('sure sınırları', () {
    expect(index.refAt(0), const AyahRef(1, 1));
    expect(index.refAt(7), const AyahRef(2, 1));
    expect(index.indexOf(const AyahRef(18, 45)), isPositive);
    expect(index.refAt(6235), const AyahRef(114, 6));
  });
}
