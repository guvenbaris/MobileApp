import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:flutter_test/flutter_test.dart';

/// NF-Y01: arayüz metinleri koda gömülmez, ARB dosyalarından gelir.
///
/// Arayüz kodunda (`presentation/` klasörleri, `core/widgets/` ve `app.dart`) harf içeren her
/// metin sabiti hata sayılır. İstisnalar:
/// - `import`/`export`/`part` yolları ve açıklamalar (annotation),
/// - `Key(...)`, `ValueKey(...)` gibi widget anahtarları,
/// - karşılaştırma ve `switch` durumlarındaki sabitler (ör. dil kodu `'ar'`),
/// - satırında `// l10n-ignore: <gerekçe>` yazan metinler (ör. mushafta her
///   dilde Arapça kalan "سُورَةُ").
/// Harf içermeyen metinler (`'$surah:$ayah'` gibi) serbesttir.
void main() {
  test('arayüz kodunda gömülü metin yok (NF-Y01)', () {
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .map((f) => f.path.replaceAll(r'\', '/'))
        .where(_isUiFile)
        .toList();
    expect(files, isNotEmpty);

    final violations = <String>[];
    for (final path in files) {
      final source = File(path).readAsStringSync();
      final unit = parseString(content: source, path: path).unit;
      final visitor = _LiteralVisitor(source);
      unit.accept(visitor);
      for (final (offset, text) in visitor.found) {
        final line = unit.lineInfo.getLocation(offset).lineNumber;
        violations.add('$path:$line  $text');
      }
    }
    expect(
      violations,
      isEmpty,
      reason:
          'Metinleri lib/l10n/app_tr.arb (ve ar, en) dosyasına taşıyın; '
          'çevrilmemesi gerekiyorsa satıra "// l10n-ignore: gerekçe" yazın.',
    );
  });

  test('denetim gömülü metni yakalar (denetimin kendisi)', () {
    const source = r'''
import 'package:flutter/material.dart';
Widget a() => const Text('Merhaba');
Widget b() => Text('Sayfa $n');
Widget c() => Text('$n:$m');
Widget d() => const SizedBox(key: Key('home.read'));
Widget e() => const Text('سُورَةُ'); // l10n-ignore: mushaf metni
bool f(String c) => c == 'ar' || switch (c) { 'tr' => true, _ => false };
''';
    final visitor = _LiteralVisitor(source);
    parseString(
      content: source,
      throwIfDiagnostics: false,
    ).unit.accept(visitor);
    expect(visitor.found.map((f) => f.$2), ["'Merhaba'", r"'Sayfa $n'"]);
  });
}

bool _isUiFile(String path) =>
    path.endsWith('.dart') &&
    !path.endsWith('.g.dart') &&
    !path.contains('/l10n/generated/') &&
    (path.contains('/presentation/') ||
        path.startsWith('lib/core/widgets/') ||
        path == 'lib/app.dart');

final _letter = RegExp(r'\p{L}', unicode: true);
const _keyTypes = {'Key', 'ValueKey', 'ObjectKey', 'PageStorageKey'};

class _LiteralVisitor extends RecursiveAstVisitor<void> {
  _LiteralVisitor(this._source);

  final String _source;
  final found = <(int, String)>[];

  @override
  void visitImportDirective(ImportDirective node) {}

  @override
  void visitExportDirective(ExportDirective node) {}

  @override
  void visitPartDirective(PartDirective node) {}

  @override
  void visitAnnotation(Annotation node) {}

  @override
  void visitConstantPattern(ConstantPattern node) {}

  @override
  void visitBinaryExpression(BinaryExpression node) {
    final op = node.operator.lexeme;
    if (op == '==' || op == '!=') return;
    super.visitBinaryExpression(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (_keyTypes.contains(node.constructorName.type.name.lexeme)) return;
    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // `const` olmadan yazılan `Key('...')`, çözümleme yapılmadığı için
    // yöntem çağrısı gibi görünür.
    if (node.target == null && _keyTypes.contains(node.methodName.name)) {
      return;
    }
    super.visitMethodInvocation(node);
  }

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) =>
      _check(node, node.value);

  @override
  void visitStringInterpolation(StringInterpolation node) {
    final text = node.elements.whereType<InterpolationString>().map(
      (e) => e.value,
    );
    _check(node, text.join());
  }

  void _check(StringLiteral node, String text) {
    if (!_letter.hasMatch(text) || _ignored(node.offset)) return;
    found.add((node.offset, node.toSource()));
  }

  /// Metnin başladığı satırda `// l10n-ignore` var mı.
  bool _ignored(int offset) {
    final end = _source.indexOf('\n', offset);
    final line = _source.substring(offset, end < 0 ? _source.length : end);
    return line.contains('// l10n-ignore');
  }
}
