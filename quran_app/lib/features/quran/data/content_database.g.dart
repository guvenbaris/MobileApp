// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_database.dart';

// ignore_for_file: type=lint
class $ContentMetaTable extends ContentMeta
    with TableInfo<$ContentMetaTable, ContentMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  ContentMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentMetaData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $ContentMetaTable createAlias(String alias) {
    return $ContentMetaTable(attachedDatabase, alias);
  }
}

class ContentMetaData extends DataClass implements Insertable<ContentMetaData> {
  final String key;
  final String value;
  const ContentMetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  ContentMetaCompanion toCompanion(bool nullToAbsent) {
    return ContentMetaCompanion(key: Value(key), value: Value(value));
  }

  factory ContentMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentMetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  ContentMetaData copyWith({String? key, String? value}) =>
      ContentMetaData(key: key ?? this.key, value: value ?? this.value);
  ContentMetaData copyWithCompanion(ContentMetaCompanion data) {
    return ContentMetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentMetaData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentMetaData &&
          other.key == this.key &&
          other.value == this.value);
}

class ContentMetaCompanion extends UpdateCompanion<ContentMetaData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const ContentMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<ContentMetaData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentMetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return ContentMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SurahsTable extends Surahs with TableInfo<$SurahsTable, SurahRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameArabicMeta = const VerificationMeta(
    'nameArabic',
  );
  @override
  late final GeneratedColumn<String> nameArabic = GeneratedColumn<String>(
    'name_arabic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameSimpleMeta = const VerificationMeta(
    'nameSimple',
  );
  @override
  late final GeneratedColumn<String> nameSimple = GeneratedColumn<String>(
    'name_simple',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameTrMeta = const VerificationMeta('nameTr');
  @override
  late final GeneratedColumn<String> nameTr = GeneratedColumn<String>(
    'name_tr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RevelationPlace, String>
  revelationPlace = GeneratedColumn<String>(
    'revelation_place',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<RevelationPlace>($SurahsTable.$converterrevelationPlace);
  static const VerificationMeta _revelationOrderMeta = const VerificationMeta(
    'revelationOrder',
  );
  @override
  late final GeneratedColumn<int> revelationOrder = GeneratedColumn<int>(
    'revelation_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bismillahPreMeta = const VerificationMeta(
    'bismillahPre',
  );
  @override
  late final GeneratedColumn<bool> bismillahPre = GeneratedColumn<bool>(
    'bismillah_pre',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("bismillah_pre" IN (0, 1))',
    ),
  );
  static const VerificationMeta _ayahCountMeta = const VerificationMeta(
    'ayahCount',
  );
  @override
  late final GeneratedColumn<int> ayahCount = GeneratedColumn<int>(
    'ayah_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameArabic,
    nameSimple,
    nameTr,
    nameEn,
    revelationPlace,
    revelationOrder,
    bismillahPre,
    ayahCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surahs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SurahRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_arabic')) {
      context.handle(
        _nameArabicMeta,
        nameArabic.isAcceptableOrUnknown(data['name_arabic']!, _nameArabicMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArabicMeta);
    }
    if (data.containsKey('name_simple')) {
      context.handle(
        _nameSimpleMeta,
        nameSimple.isAcceptableOrUnknown(data['name_simple']!, _nameSimpleMeta),
      );
    } else if (isInserting) {
      context.missing(_nameSimpleMeta);
    }
    if (data.containsKey('name_tr')) {
      context.handle(
        _nameTrMeta,
        nameTr.isAcceptableOrUnknown(data['name_tr']!, _nameTrMeta),
      );
    } else if (isInserting) {
      context.missing(_nameTrMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('revelation_order')) {
      context.handle(
        _revelationOrderMeta,
        revelationOrder.isAcceptableOrUnknown(
          data['revelation_order']!,
          _revelationOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_revelationOrderMeta);
    }
    if (data.containsKey('bismillah_pre')) {
      context.handle(
        _bismillahPreMeta,
        bismillahPre.isAcceptableOrUnknown(
          data['bismillah_pre']!,
          _bismillahPreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bismillahPreMeta);
    }
    if (data.containsKey('ayah_count')) {
      context.handle(
        _ayahCountMeta,
        ayahCount.isAcceptableOrUnknown(data['ayah_count']!, _ayahCountMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SurahRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurahRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameArabic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_arabic'],
      )!,
      nameSimple: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_simple'],
      )!,
      nameTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_tr'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      revelationPlace: $SurahsTable.$converterrevelationPlace.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}revelation_place'],
        )!,
      ),
      revelationOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revelation_order'],
      )!,
      bismillahPre: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}bismillah_pre'],
      )!,
      ayahCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_count'],
      )!,
    );
  }

  @override
  $SurahsTable createAlias(String alias) {
    return $SurahsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RevelationPlace, String, String>
  $converterrevelationPlace = const EnumNameConverter<RevelationPlace>(
    RevelationPlace.values,
  );
}

class SurahRow extends DataClass implements Insertable<SurahRow> {
  final int id;
  final String nameArabic;
  final String nameSimple;
  final String nameTr;
  final String nameEn;
  final RevelationPlace revelationPlace;
  final int revelationOrder;
  final bool bismillahPre;
  final int ayahCount;
  const SurahRow({
    required this.id,
    required this.nameArabic,
    required this.nameSimple,
    required this.nameTr,
    required this.nameEn,
    required this.revelationPlace,
    required this.revelationOrder,
    required this.bismillahPre,
    required this.ayahCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_arabic'] = Variable<String>(nameArabic);
    map['name_simple'] = Variable<String>(nameSimple);
    map['name_tr'] = Variable<String>(nameTr);
    map['name_en'] = Variable<String>(nameEn);
    {
      map['revelation_place'] = Variable<String>(
        $SurahsTable.$converterrevelationPlace.toSql(revelationPlace),
      );
    }
    map['revelation_order'] = Variable<int>(revelationOrder);
    map['bismillah_pre'] = Variable<bool>(bismillahPre);
    map['ayah_count'] = Variable<int>(ayahCount);
    return map;
  }

  SurahsCompanion toCompanion(bool nullToAbsent) {
    return SurahsCompanion(
      id: Value(id),
      nameArabic: Value(nameArabic),
      nameSimple: Value(nameSimple),
      nameTr: Value(nameTr),
      nameEn: Value(nameEn),
      revelationPlace: Value(revelationPlace),
      revelationOrder: Value(revelationOrder),
      bismillahPre: Value(bismillahPre),
      ayahCount: Value(ayahCount),
    );
  }

  factory SurahRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SurahRow(
      id: serializer.fromJson<int>(json['id']),
      nameArabic: serializer.fromJson<String>(json['nameArabic']),
      nameSimple: serializer.fromJson<String>(json['nameSimple']),
      nameTr: serializer.fromJson<String>(json['nameTr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      revelationPlace: $SurahsTable.$converterrevelationPlace.fromJson(
        serializer.fromJson<String>(json['revelationPlace']),
      ),
      revelationOrder: serializer.fromJson<int>(json['revelationOrder']),
      bismillahPre: serializer.fromJson<bool>(json['bismillahPre']),
      ayahCount: serializer.fromJson<int>(json['ayahCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameArabic': serializer.toJson<String>(nameArabic),
      'nameSimple': serializer.toJson<String>(nameSimple),
      'nameTr': serializer.toJson<String>(nameTr),
      'nameEn': serializer.toJson<String>(nameEn),
      'revelationPlace': serializer.toJson<String>(
        $SurahsTable.$converterrevelationPlace.toJson(revelationPlace),
      ),
      'revelationOrder': serializer.toJson<int>(revelationOrder),
      'bismillahPre': serializer.toJson<bool>(bismillahPre),
      'ayahCount': serializer.toJson<int>(ayahCount),
    };
  }

  SurahRow copyWith({
    int? id,
    String? nameArabic,
    String? nameSimple,
    String? nameTr,
    String? nameEn,
    RevelationPlace? revelationPlace,
    int? revelationOrder,
    bool? bismillahPre,
    int? ayahCount,
  }) => SurahRow(
    id: id ?? this.id,
    nameArabic: nameArabic ?? this.nameArabic,
    nameSimple: nameSimple ?? this.nameSimple,
    nameTr: nameTr ?? this.nameTr,
    nameEn: nameEn ?? this.nameEn,
    revelationPlace: revelationPlace ?? this.revelationPlace,
    revelationOrder: revelationOrder ?? this.revelationOrder,
    bismillahPre: bismillahPre ?? this.bismillahPre,
    ayahCount: ayahCount ?? this.ayahCount,
  );
  SurahRow copyWithCompanion(SurahsCompanion data) {
    return SurahRow(
      id: data.id.present ? data.id.value : this.id,
      nameArabic: data.nameArabic.present
          ? data.nameArabic.value
          : this.nameArabic,
      nameSimple: data.nameSimple.present
          ? data.nameSimple.value
          : this.nameSimple,
      nameTr: data.nameTr.present ? data.nameTr.value : this.nameTr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      revelationPlace: data.revelationPlace.present
          ? data.revelationPlace.value
          : this.revelationPlace,
      revelationOrder: data.revelationOrder.present
          ? data.revelationOrder.value
          : this.revelationOrder,
      bismillahPre: data.bismillahPre.present
          ? data.bismillahPre.value
          : this.bismillahPre,
      ayahCount: data.ayahCount.present ? data.ayahCount.value : this.ayahCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SurahRow(')
          ..write('id: $id, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameSimple: $nameSimple, ')
          ..write('nameTr: $nameTr, ')
          ..write('nameEn: $nameEn, ')
          ..write('revelationPlace: $revelationPlace, ')
          ..write('revelationOrder: $revelationOrder, ')
          ..write('bismillahPre: $bismillahPre, ')
          ..write('ayahCount: $ayahCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nameArabic,
    nameSimple,
    nameTr,
    nameEn,
    revelationPlace,
    revelationOrder,
    bismillahPre,
    ayahCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurahRow &&
          other.id == this.id &&
          other.nameArabic == this.nameArabic &&
          other.nameSimple == this.nameSimple &&
          other.nameTr == this.nameTr &&
          other.nameEn == this.nameEn &&
          other.revelationPlace == this.revelationPlace &&
          other.revelationOrder == this.revelationOrder &&
          other.bismillahPre == this.bismillahPre &&
          other.ayahCount == this.ayahCount);
}

class SurahsCompanion extends UpdateCompanion<SurahRow> {
  final Value<int> id;
  final Value<String> nameArabic;
  final Value<String> nameSimple;
  final Value<String> nameTr;
  final Value<String> nameEn;
  final Value<RevelationPlace> revelationPlace;
  final Value<int> revelationOrder;
  final Value<bool> bismillahPre;
  final Value<int> ayahCount;
  const SurahsCompanion({
    this.id = const Value.absent(),
    this.nameArabic = const Value.absent(),
    this.nameSimple = const Value.absent(),
    this.nameTr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.revelationPlace = const Value.absent(),
    this.revelationOrder = const Value.absent(),
    this.bismillahPre = const Value.absent(),
    this.ayahCount = const Value.absent(),
  });
  SurahsCompanion.insert({
    this.id = const Value.absent(),
    required String nameArabic,
    required String nameSimple,
    required String nameTr,
    required String nameEn,
    required RevelationPlace revelationPlace,
    required int revelationOrder,
    required bool bismillahPre,
    required int ayahCount,
  }) : nameArabic = Value(nameArabic),
       nameSimple = Value(nameSimple),
       nameTr = Value(nameTr),
       nameEn = Value(nameEn),
       revelationPlace = Value(revelationPlace),
       revelationOrder = Value(revelationOrder),
       bismillahPre = Value(bismillahPre),
       ayahCount = Value(ayahCount);
  static Insertable<SurahRow> custom({
    Expression<int>? id,
    Expression<String>? nameArabic,
    Expression<String>? nameSimple,
    Expression<String>? nameTr,
    Expression<String>? nameEn,
    Expression<String>? revelationPlace,
    Expression<int>? revelationOrder,
    Expression<bool>? bismillahPre,
    Expression<int>? ayahCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (nameSimple != null) 'name_simple': nameSimple,
      if (nameTr != null) 'name_tr': nameTr,
      if (nameEn != null) 'name_en': nameEn,
      if (revelationPlace != null) 'revelation_place': revelationPlace,
      if (revelationOrder != null) 'revelation_order': revelationOrder,
      if (bismillahPre != null) 'bismillah_pre': bismillahPre,
      if (ayahCount != null) 'ayah_count': ayahCount,
    });
  }

  SurahsCompanion copyWith({
    Value<int>? id,
    Value<String>? nameArabic,
    Value<String>? nameSimple,
    Value<String>? nameTr,
    Value<String>? nameEn,
    Value<RevelationPlace>? revelationPlace,
    Value<int>? revelationOrder,
    Value<bool>? bismillahPre,
    Value<int>? ayahCount,
  }) {
    return SurahsCompanion(
      id: id ?? this.id,
      nameArabic: nameArabic ?? this.nameArabic,
      nameSimple: nameSimple ?? this.nameSimple,
      nameTr: nameTr ?? this.nameTr,
      nameEn: nameEn ?? this.nameEn,
      revelationPlace: revelationPlace ?? this.revelationPlace,
      revelationOrder: revelationOrder ?? this.revelationOrder,
      bismillahPre: bismillahPre ?? this.bismillahPre,
      ayahCount: ayahCount ?? this.ayahCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameArabic.present) {
      map['name_arabic'] = Variable<String>(nameArabic.value);
    }
    if (nameSimple.present) {
      map['name_simple'] = Variable<String>(nameSimple.value);
    }
    if (nameTr.present) {
      map['name_tr'] = Variable<String>(nameTr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (revelationPlace.present) {
      map['revelation_place'] = Variable<String>(
        $SurahsTable.$converterrevelationPlace.toSql(revelationPlace.value),
      );
    }
    if (revelationOrder.present) {
      map['revelation_order'] = Variable<int>(revelationOrder.value);
    }
    if (bismillahPre.present) {
      map['bismillah_pre'] = Variable<bool>(bismillahPre.value);
    }
    if (ayahCount.present) {
      map['ayah_count'] = Variable<int>(ayahCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('id: $id, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameSimple: $nameSimple, ')
          ..write('nameTr: $nameTr, ')
          ..write('nameEn: $nameEn, ')
          ..write('revelationPlace: $revelationPlace, ')
          ..write('revelationOrder: $revelationOrder, ')
          ..write('bismillahPre: $bismillahPre, ')
          ..write('ayahCount: $ayahCount')
          ..write(')'))
        .toString();
  }
}

class $AyahsTable extends Ayahs with TableInfo<$AyahsTable, AyahRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AyahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _surahMeta = const VerificationMeta('surah');
  @override
  late final GeneratedColumn<int> surah = GeneratedColumn<int>(
    'surah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES surahs (id)',
    ),
  );
  static const VerificationMeta _ayahMeta = const VerificationMeta('ayah');
  @override
  late final GeneratedColumn<int> ayah = GeneratedColumn<int>(
    'ayah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _juzMeta = const VerificationMeta('juz');
  @override
  late final GeneratedColumn<int> juz = GeneratedColumn<int>(
    'juz',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hizbMeta = const VerificationMeta('hizb');
  @override
  late final GeneratedColumn<int> hizb = GeneratedColumn<int>(
    'hizb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rubMeta = const VerificationMeta('rub');
  @override
  late final GeneratedColumn<int> rub = GeneratedColumn<int>(
    'rub',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sajdahMeta = const VerificationMeta('sajdah');
  @override
  late final GeneratedColumn<int> sajdah = GeneratedColumn<int>(
    'sajdah',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _textUthmaniMeta = const VerificationMeta(
    'textUthmani',
  );
  @override
  late final GeneratedColumn<String> textUthmani = GeneratedColumn<String>(
    'text_uthmani',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textQpcHafsMeta = const VerificationMeta(
    'textQpcHafs',
  );
  @override
  late final GeneratedColumn<String> textQpcHafs = GeneratedColumn<String>(
    'text_qpc_hafs',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textDigitalKhattMeta = const VerificationMeta(
    'textDigitalKhatt',
  );
  @override
  late final GeneratedColumn<String> textDigitalKhatt = GeneratedColumn<String>(
    'text_digital_khatt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surah,
    ayah,
    juz,
    hizb,
    rub,
    sajdah,
    textUthmani,
    textQpcHafs,
    textDigitalKhatt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ayahs';
  @override
  VerificationContext validateIntegrity(
    Insertable<AyahRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah')) {
      context.handle(
        _surahMeta,
        surah.isAcceptableOrUnknown(data['surah']!, _surahMeta),
      );
    } else if (isInserting) {
      context.missing(_surahMeta);
    }
    if (data.containsKey('ayah')) {
      context.handle(
        _ayahMeta,
        ayah.isAcceptableOrUnknown(data['ayah']!, _ayahMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahMeta);
    }
    if (data.containsKey('juz')) {
      context.handle(
        _juzMeta,
        juz.isAcceptableOrUnknown(data['juz']!, _juzMeta),
      );
    } else if (isInserting) {
      context.missing(_juzMeta);
    }
    if (data.containsKey('hizb')) {
      context.handle(
        _hizbMeta,
        hizb.isAcceptableOrUnknown(data['hizb']!, _hizbMeta),
      );
    } else if (isInserting) {
      context.missing(_hizbMeta);
    }
    if (data.containsKey('rub')) {
      context.handle(
        _rubMeta,
        rub.isAcceptableOrUnknown(data['rub']!, _rubMeta),
      );
    } else if (isInserting) {
      context.missing(_rubMeta);
    }
    if (data.containsKey('sajdah')) {
      context.handle(
        _sajdahMeta,
        sajdah.isAcceptableOrUnknown(data['sajdah']!, _sajdahMeta),
      );
    }
    if (data.containsKey('text_uthmani')) {
      context.handle(
        _textUthmaniMeta,
        textUthmani.isAcceptableOrUnknown(
          data['text_uthmani']!,
          _textUthmaniMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_textUthmaniMeta);
    }
    if (data.containsKey('text_qpc_hafs')) {
      context.handle(
        _textQpcHafsMeta,
        textQpcHafs.isAcceptableOrUnknown(
          data['text_qpc_hafs']!,
          _textQpcHafsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_textQpcHafsMeta);
    }
    if (data.containsKey('text_digital_khatt')) {
      context.handle(
        _textDigitalKhattMeta,
        textDigitalKhatt.isAcceptableOrUnknown(
          data['text_digital_khatt']!,
          _textDigitalKhattMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_textDigitalKhattMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {surah, ayah},
  ];
  @override
  AyahRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AyahRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah'],
      )!,
      ayah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah'],
      )!,
      juz: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}juz'],
      )!,
      hizb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hizb'],
      )!,
      rub: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rub'],
      )!,
      sajdah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sajdah'],
      ),
      textUthmani: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_uthmani'],
      )!,
      textQpcHafs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_qpc_hafs'],
      )!,
      textDigitalKhatt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_digital_khatt'],
      )!,
    );
  }

  @override
  $AyahsTable createAlias(String alias) {
    return $AyahsTable(attachedDatabase, alias);
  }
}

class AyahRow extends DataClass implements Insertable<AyahRow> {
  final int id;
  final int surah;
  final int ayah;
  final int juz;
  final int hizb;
  final int rub;
  final int? sajdah;
  final String textUthmani;
  final String textQpcHafs;

  /// Ekranda gösterilen metin: DigitalKhatt yazılışı (kelimeler + ayet sonu
  /// işareti). Harfleri ve durak işaretleri T-01'de KFGQPC metniyle denetlenir.
  final String textDigitalKhatt;
  const AyahRow({
    required this.id,
    required this.surah,
    required this.ayah,
    required this.juz,
    required this.hizb,
    required this.rub,
    this.sajdah,
    required this.textUthmani,
    required this.textQpcHafs,
    required this.textDigitalKhatt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah'] = Variable<int>(surah);
    map['ayah'] = Variable<int>(ayah);
    map['juz'] = Variable<int>(juz);
    map['hizb'] = Variable<int>(hizb);
    map['rub'] = Variable<int>(rub);
    if (!nullToAbsent || sajdah != null) {
      map['sajdah'] = Variable<int>(sajdah);
    }
    map['text_uthmani'] = Variable<String>(textUthmani);
    map['text_qpc_hafs'] = Variable<String>(textQpcHafs);
    map['text_digital_khatt'] = Variable<String>(textDigitalKhatt);
    return map;
  }

  AyahsCompanion toCompanion(bool nullToAbsent) {
    return AyahsCompanion(
      id: Value(id),
      surah: Value(surah),
      ayah: Value(ayah),
      juz: Value(juz),
      hizb: Value(hizb),
      rub: Value(rub),
      sajdah: sajdah == null && nullToAbsent
          ? const Value.absent()
          : Value(sajdah),
      textUthmani: Value(textUthmani),
      textQpcHafs: Value(textQpcHafs),
      textDigitalKhatt: Value(textDigitalKhatt),
    );
  }

  factory AyahRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AyahRow(
      id: serializer.fromJson<int>(json['id']),
      surah: serializer.fromJson<int>(json['surah']),
      ayah: serializer.fromJson<int>(json['ayah']),
      juz: serializer.fromJson<int>(json['juz']),
      hizb: serializer.fromJson<int>(json['hizb']),
      rub: serializer.fromJson<int>(json['rub']),
      sajdah: serializer.fromJson<int?>(json['sajdah']),
      textUthmani: serializer.fromJson<String>(json['textUthmani']),
      textQpcHafs: serializer.fromJson<String>(json['textQpcHafs']),
      textDigitalKhatt: serializer.fromJson<String>(json['textDigitalKhatt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surah': serializer.toJson<int>(surah),
      'ayah': serializer.toJson<int>(ayah),
      'juz': serializer.toJson<int>(juz),
      'hizb': serializer.toJson<int>(hizb),
      'rub': serializer.toJson<int>(rub),
      'sajdah': serializer.toJson<int?>(sajdah),
      'textUthmani': serializer.toJson<String>(textUthmani),
      'textQpcHafs': serializer.toJson<String>(textQpcHafs),
      'textDigitalKhatt': serializer.toJson<String>(textDigitalKhatt),
    };
  }

  AyahRow copyWith({
    int? id,
    int? surah,
    int? ayah,
    int? juz,
    int? hizb,
    int? rub,
    Value<int?> sajdah = const Value.absent(),
    String? textUthmani,
    String? textQpcHafs,
    String? textDigitalKhatt,
  }) => AyahRow(
    id: id ?? this.id,
    surah: surah ?? this.surah,
    ayah: ayah ?? this.ayah,
    juz: juz ?? this.juz,
    hizb: hizb ?? this.hizb,
    rub: rub ?? this.rub,
    sajdah: sajdah.present ? sajdah.value : this.sajdah,
    textUthmani: textUthmani ?? this.textUthmani,
    textQpcHafs: textQpcHafs ?? this.textQpcHafs,
    textDigitalKhatt: textDigitalKhatt ?? this.textDigitalKhatt,
  );
  AyahRow copyWithCompanion(AyahsCompanion data) {
    return AyahRow(
      id: data.id.present ? data.id.value : this.id,
      surah: data.surah.present ? data.surah.value : this.surah,
      ayah: data.ayah.present ? data.ayah.value : this.ayah,
      juz: data.juz.present ? data.juz.value : this.juz,
      hizb: data.hizb.present ? data.hizb.value : this.hizb,
      rub: data.rub.present ? data.rub.value : this.rub,
      sajdah: data.sajdah.present ? data.sajdah.value : this.sajdah,
      textUthmani: data.textUthmani.present
          ? data.textUthmani.value
          : this.textUthmani,
      textQpcHafs: data.textQpcHafs.present
          ? data.textQpcHafs.value
          : this.textQpcHafs,
      textDigitalKhatt: data.textDigitalKhatt.present
          ? data.textDigitalKhatt.value
          : this.textDigitalKhatt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AyahRow(')
          ..write('id: $id, ')
          ..write('surah: $surah, ')
          ..write('ayah: $ayah, ')
          ..write('juz: $juz, ')
          ..write('hizb: $hizb, ')
          ..write('rub: $rub, ')
          ..write('sajdah: $sajdah, ')
          ..write('textUthmani: $textUthmani, ')
          ..write('textQpcHafs: $textQpcHafs, ')
          ..write('textDigitalKhatt: $textDigitalKhatt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    surah,
    ayah,
    juz,
    hizb,
    rub,
    sajdah,
    textUthmani,
    textQpcHafs,
    textDigitalKhatt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AyahRow &&
          other.id == this.id &&
          other.surah == this.surah &&
          other.ayah == this.ayah &&
          other.juz == this.juz &&
          other.hizb == this.hizb &&
          other.rub == this.rub &&
          other.sajdah == this.sajdah &&
          other.textUthmani == this.textUthmani &&
          other.textQpcHafs == this.textQpcHafs &&
          other.textDigitalKhatt == this.textDigitalKhatt);
}

class AyahsCompanion extends UpdateCompanion<AyahRow> {
  final Value<int> id;
  final Value<int> surah;
  final Value<int> ayah;
  final Value<int> juz;
  final Value<int> hizb;
  final Value<int> rub;
  final Value<int?> sajdah;
  final Value<String> textUthmani;
  final Value<String> textQpcHafs;
  final Value<String> textDigitalKhatt;
  const AyahsCompanion({
    this.id = const Value.absent(),
    this.surah = const Value.absent(),
    this.ayah = const Value.absent(),
    this.juz = const Value.absent(),
    this.hizb = const Value.absent(),
    this.rub = const Value.absent(),
    this.sajdah = const Value.absent(),
    this.textUthmani = const Value.absent(),
    this.textQpcHafs = const Value.absent(),
    this.textDigitalKhatt = const Value.absent(),
  });
  AyahsCompanion.insert({
    this.id = const Value.absent(),
    required int surah,
    required int ayah,
    required int juz,
    required int hizb,
    required int rub,
    this.sajdah = const Value.absent(),
    required String textUthmani,
    required String textQpcHafs,
    required String textDigitalKhatt,
  }) : surah = Value(surah),
       ayah = Value(ayah),
       juz = Value(juz),
       hizb = Value(hizb),
       rub = Value(rub),
       textUthmani = Value(textUthmani),
       textQpcHafs = Value(textQpcHafs),
       textDigitalKhatt = Value(textDigitalKhatt);
  static Insertable<AyahRow> custom({
    Expression<int>? id,
    Expression<int>? surah,
    Expression<int>? ayah,
    Expression<int>? juz,
    Expression<int>? hizb,
    Expression<int>? rub,
    Expression<int>? sajdah,
    Expression<String>? textUthmani,
    Expression<String>? textQpcHafs,
    Expression<String>? textDigitalKhatt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surah != null) 'surah': surah,
      if (ayah != null) 'ayah': ayah,
      if (juz != null) 'juz': juz,
      if (hizb != null) 'hizb': hizb,
      if (rub != null) 'rub': rub,
      if (sajdah != null) 'sajdah': sajdah,
      if (textUthmani != null) 'text_uthmani': textUthmani,
      if (textQpcHafs != null) 'text_qpc_hafs': textQpcHafs,
      if (textDigitalKhatt != null) 'text_digital_khatt': textDigitalKhatt,
    });
  }

  AyahsCompanion copyWith({
    Value<int>? id,
    Value<int>? surah,
    Value<int>? ayah,
    Value<int>? juz,
    Value<int>? hizb,
    Value<int>? rub,
    Value<int?>? sajdah,
    Value<String>? textUthmani,
    Value<String>? textQpcHafs,
    Value<String>? textDigitalKhatt,
  }) {
    return AyahsCompanion(
      id: id ?? this.id,
      surah: surah ?? this.surah,
      ayah: ayah ?? this.ayah,
      juz: juz ?? this.juz,
      hizb: hizb ?? this.hizb,
      rub: rub ?? this.rub,
      sajdah: sajdah ?? this.sajdah,
      textUthmani: textUthmani ?? this.textUthmani,
      textQpcHafs: textQpcHafs ?? this.textQpcHafs,
      textDigitalKhatt: textDigitalKhatt ?? this.textDigitalKhatt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surah.present) {
      map['surah'] = Variable<int>(surah.value);
    }
    if (ayah.present) {
      map['ayah'] = Variable<int>(ayah.value);
    }
    if (juz.present) {
      map['juz'] = Variable<int>(juz.value);
    }
    if (hizb.present) {
      map['hizb'] = Variable<int>(hizb.value);
    }
    if (rub.present) {
      map['rub'] = Variable<int>(rub.value);
    }
    if (sajdah.present) {
      map['sajdah'] = Variable<int>(sajdah.value);
    }
    if (textUthmani.present) {
      map['text_uthmani'] = Variable<String>(textUthmani.value);
    }
    if (textQpcHafs.present) {
      map['text_qpc_hafs'] = Variable<String>(textQpcHafs.value);
    }
    if (textDigitalKhatt.present) {
      map['text_digital_khatt'] = Variable<String>(textDigitalKhatt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahsCompanion(')
          ..write('id: $id, ')
          ..write('surah: $surah, ')
          ..write('ayah: $ayah, ')
          ..write('juz: $juz, ')
          ..write('hizb: $hizb, ')
          ..write('rub: $rub, ')
          ..write('sajdah: $sajdah, ')
          ..write('textUthmani: $textUthmani, ')
          ..write('textQpcHafs: $textQpcHafs, ')
          ..write('textDigitalKhatt: $textDigitalKhatt')
          ..write(')'))
        .toString();
  }
}

class $WordsTable extends Words with TableInfo<$WordsTable, WordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ayahIdMeta = const VerificationMeta('ayahId');
  @override
  late final GeneratedColumn<int> ayahId = GeneratedColumn<int>(
    'ayah_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ayahs (id)',
    ),
  );
  static const VerificationMeta _surahMeta = const VerificationMeta('surah');
  @override
  late final GeneratedColumn<int> surah = GeneratedColumn<int>(
    'surah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahMeta = const VerificationMeta('ayah');
  @override
  late final GeneratedColumn<int> ayah = GeneratedColumn<int>(
    'ayah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAyahEndMeta = const VerificationMeta(
    'isAyahEnd',
  );
  @override
  late final GeneratedColumn<bool> isAyahEnd = GeneratedColumn<bool>(
    'is_ayah_end',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_ayah_end" IN (0, 1))',
    ),
  );
  static const VerificationMeta _wordTextMeta = const VerificationMeta(
    'wordText',
  );
  @override
  late final GeneratedColumn<String> wordText = GeneratedColumn<String>(
    'word_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _morphFirstMeta = const VerificationMeta(
    'morphFirst',
  );
  @override
  late final GeneratedColumn<int> morphFirst = GeneratedColumn<int>(
    'morph_first',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _morphLastMeta = const VerificationMeta(
    'morphLast',
  );
  @override
  late final GeneratedColumn<int> morphLast = GeneratedColumn<int>(
    'morph_last',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ayahId,
    surah,
    ayah,
    position,
    isAyahEnd,
    wordText,
    morphFirst,
    morphLast,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ayah_id')) {
      context.handle(
        _ayahIdMeta,
        ayahId.isAcceptableOrUnknown(data['ayah_id']!, _ayahIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahIdMeta);
    }
    if (data.containsKey('surah')) {
      context.handle(
        _surahMeta,
        surah.isAcceptableOrUnknown(data['surah']!, _surahMeta),
      );
    } else if (isInserting) {
      context.missing(_surahMeta);
    }
    if (data.containsKey('ayah')) {
      context.handle(
        _ayahMeta,
        ayah.isAcceptableOrUnknown(data['ayah']!, _ayahMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('is_ayah_end')) {
      context.handle(
        _isAyahEndMeta,
        isAyahEnd.isAcceptableOrUnknown(data['is_ayah_end']!, _isAyahEndMeta),
      );
    } else if (isInserting) {
      context.missing(_isAyahEndMeta);
    }
    if (data.containsKey('word_text')) {
      context.handle(
        _wordTextMeta,
        wordText.isAcceptableOrUnknown(data['word_text']!, _wordTextMeta),
      );
    } else if (isInserting) {
      context.missing(_wordTextMeta);
    }
    if (data.containsKey('morph_first')) {
      context.handle(
        _morphFirstMeta,
        morphFirst.isAcceptableOrUnknown(data['morph_first']!, _morphFirstMeta),
      );
    } else if (isInserting) {
      context.missing(_morphFirstMeta);
    }
    if (data.containsKey('morph_last')) {
      context.handle(
        _morphLastMeta,
        morphLast.isAcceptableOrUnknown(data['morph_last']!, _morphLastMeta),
      );
    } else if (isInserting) {
      context.missing(_morphLastMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {surah, ayah, position},
  ];
  @override
  WordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ayahId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_id'],
      )!,
      surah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah'],
      )!,
      ayah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      isAyahEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_ayah_end'],
      )!,
      wordText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_text'],
      )!,
      morphFirst: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}morph_first'],
      )!,
      morphLast: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}morph_last'],
      )!,
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }
}

class WordRow extends DataClass implements Insertable<WordRow> {
  final int id;
  final int ayahId;
  final int surah;
  final int ayah;

  /// Ayet içindeki sıra (1'den başlar); ayet sonu işareti son sıradadır.
  final int position;

  /// Ayet sonu (numara) işareti mi.
  final bool isAyahEnd;

  /// KFGQPC metnindeki yazılışı.
  final String wordText;

  /// Quran.com/Corpus kelime bölünmesinde karşılık gelen sıra aralığı
  /// (kelime meali ve ses verileri için). 7 yer dışında ikisi eşittir.
  final int morphFirst;
  final int morphLast;
  const WordRow({
    required this.id,
    required this.ayahId,
    required this.surah,
    required this.ayah,
    required this.position,
    required this.isAyahEnd,
    required this.wordText,
    required this.morphFirst,
    required this.morphLast,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ayah_id'] = Variable<int>(ayahId);
    map['surah'] = Variable<int>(surah);
    map['ayah'] = Variable<int>(ayah);
    map['position'] = Variable<int>(position);
    map['is_ayah_end'] = Variable<bool>(isAyahEnd);
    map['word_text'] = Variable<String>(wordText);
    map['morph_first'] = Variable<int>(morphFirst);
    map['morph_last'] = Variable<int>(morphLast);
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      ayahId: Value(ayahId),
      surah: Value(surah),
      ayah: Value(ayah),
      position: Value(position),
      isAyahEnd: Value(isAyahEnd),
      wordText: Value(wordText),
      morphFirst: Value(morphFirst),
      morphLast: Value(morphLast),
    );
  }

  factory WordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordRow(
      id: serializer.fromJson<int>(json['id']),
      ayahId: serializer.fromJson<int>(json['ayahId']),
      surah: serializer.fromJson<int>(json['surah']),
      ayah: serializer.fromJson<int>(json['ayah']),
      position: serializer.fromJson<int>(json['position']),
      isAyahEnd: serializer.fromJson<bool>(json['isAyahEnd']),
      wordText: serializer.fromJson<String>(json['wordText']),
      morphFirst: serializer.fromJson<int>(json['morphFirst']),
      morphLast: serializer.fromJson<int>(json['morphLast']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ayahId': serializer.toJson<int>(ayahId),
      'surah': serializer.toJson<int>(surah),
      'ayah': serializer.toJson<int>(ayah),
      'position': serializer.toJson<int>(position),
      'isAyahEnd': serializer.toJson<bool>(isAyahEnd),
      'wordText': serializer.toJson<String>(wordText),
      'morphFirst': serializer.toJson<int>(morphFirst),
      'morphLast': serializer.toJson<int>(morphLast),
    };
  }

  WordRow copyWith({
    int? id,
    int? ayahId,
    int? surah,
    int? ayah,
    int? position,
    bool? isAyahEnd,
    String? wordText,
    int? morphFirst,
    int? morphLast,
  }) => WordRow(
    id: id ?? this.id,
    ayahId: ayahId ?? this.ayahId,
    surah: surah ?? this.surah,
    ayah: ayah ?? this.ayah,
    position: position ?? this.position,
    isAyahEnd: isAyahEnd ?? this.isAyahEnd,
    wordText: wordText ?? this.wordText,
    morphFirst: morphFirst ?? this.morphFirst,
    morphLast: morphLast ?? this.morphLast,
  );
  WordRow copyWithCompanion(WordsCompanion data) {
    return WordRow(
      id: data.id.present ? data.id.value : this.id,
      ayahId: data.ayahId.present ? data.ayahId.value : this.ayahId,
      surah: data.surah.present ? data.surah.value : this.surah,
      ayah: data.ayah.present ? data.ayah.value : this.ayah,
      position: data.position.present ? data.position.value : this.position,
      isAyahEnd: data.isAyahEnd.present ? data.isAyahEnd.value : this.isAyahEnd,
      wordText: data.wordText.present ? data.wordText.value : this.wordText,
      morphFirst: data.morphFirst.present
          ? data.morphFirst.value
          : this.morphFirst,
      morphLast: data.morphLast.present ? data.morphLast.value : this.morphLast,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordRow(')
          ..write('id: $id, ')
          ..write('ayahId: $ayahId, ')
          ..write('surah: $surah, ')
          ..write('ayah: $ayah, ')
          ..write('position: $position, ')
          ..write('isAyahEnd: $isAyahEnd, ')
          ..write('wordText: $wordText, ')
          ..write('morphFirst: $morphFirst, ')
          ..write('morphLast: $morphLast')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ayahId,
    surah,
    ayah,
    position,
    isAyahEnd,
    wordText,
    morphFirst,
    morphLast,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordRow &&
          other.id == this.id &&
          other.ayahId == this.ayahId &&
          other.surah == this.surah &&
          other.ayah == this.ayah &&
          other.position == this.position &&
          other.isAyahEnd == this.isAyahEnd &&
          other.wordText == this.wordText &&
          other.morphFirst == this.morphFirst &&
          other.morphLast == this.morphLast);
}

class WordsCompanion extends UpdateCompanion<WordRow> {
  final Value<int> id;
  final Value<int> ayahId;
  final Value<int> surah;
  final Value<int> ayah;
  final Value<int> position;
  final Value<bool> isAyahEnd;
  final Value<String> wordText;
  final Value<int> morphFirst;
  final Value<int> morphLast;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.ayahId = const Value.absent(),
    this.surah = const Value.absent(),
    this.ayah = const Value.absent(),
    this.position = const Value.absent(),
    this.isAyahEnd = const Value.absent(),
    this.wordText = const Value.absent(),
    this.morphFirst = const Value.absent(),
    this.morphLast = const Value.absent(),
  });
  WordsCompanion.insert({
    this.id = const Value.absent(),
    required int ayahId,
    required int surah,
    required int ayah,
    required int position,
    required bool isAyahEnd,
    required String wordText,
    required int morphFirst,
    required int morphLast,
  }) : ayahId = Value(ayahId),
       surah = Value(surah),
       ayah = Value(ayah),
       position = Value(position),
       isAyahEnd = Value(isAyahEnd),
       wordText = Value(wordText),
       morphFirst = Value(morphFirst),
       morphLast = Value(morphLast);
  static Insertable<WordRow> custom({
    Expression<int>? id,
    Expression<int>? ayahId,
    Expression<int>? surah,
    Expression<int>? ayah,
    Expression<int>? position,
    Expression<bool>? isAyahEnd,
    Expression<String>? wordText,
    Expression<int>? morphFirst,
    Expression<int>? morphLast,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ayahId != null) 'ayah_id': ayahId,
      if (surah != null) 'surah': surah,
      if (ayah != null) 'ayah': ayah,
      if (position != null) 'position': position,
      if (isAyahEnd != null) 'is_ayah_end': isAyahEnd,
      if (wordText != null) 'word_text': wordText,
      if (morphFirst != null) 'morph_first': morphFirst,
      if (morphLast != null) 'morph_last': morphLast,
    });
  }

  WordsCompanion copyWith({
    Value<int>? id,
    Value<int>? ayahId,
    Value<int>? surah,
    Value<int>? ayah,
    Value<int>? position,
    Value<bool>? isAyahEnd,
    Value<String>? wordText,
    Value<int>? morphFirst,
    Value<int>? morphLast,
  }) {
    return WordsCompanion(
      id: id ?? this.id,
      ayahId: ayahId ?? this.ayahId,
      surah: surah ?? this.surah,
      ayah: ayah ?? this.ayah,
      position: position ?? this.position,
      isAyahEnd: isAyahEnd ?? this.isAyahEnd,
      wordText: wordText ?? this.wordText,
      morphFirst: morphFirst ?? this.morphFirst,
      morphLast: morphLast ?? this.morphLast,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ayahId.present) {
      map['ayah_id'] = Variable<int>(ayahId.value);
    }
    if (surah.present) {
      map['surah'] = Variable<int>(surah.value);
    }
    if (ayah.present) {
      map['ayah'] = Variable<int>(ayah.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (isAyahEnd.present) {
      map['is_ayah_end'] = Variable<bool>(isAyahEnd.value);
    }
    if (wordText.present) {
      map['word_text'] = Variable<String>(wordText.value);
    }
    if (morphFirst.present) {
      map['morph_first'] = Variable<int>(morphFirst.value);
    }
    if (morphLast.present) {
      map['morph_last'] = Variable<int>(morphLast.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('ayahId: $ayahId, ')
          ..write('surah: $surah, ')
          ..write('ayah: $ayah, ')
          ..write('position: $position, ')
          ..write('isAyahEnd: $isAyahEnd, ')
          ..write('wordText: $wordText, ')
          ..write('morphFirst: $morphFirst, ')
          ..write('morphLast: $morphLast')
          ..write(')'))
        .toString();
  }
}

class $MushafLayoutsTable extends MushafLayouts
    with TableInfo<$MushafLayoutsTable, MushafLayoutRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MushafLayoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageCountMeta = const VerificationMeta(
    'pageCount',
  );
  @override
  late final GeneratedColumn<int> pageCount = GeneratedColumn<int>(
    'page_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linesPerPageMeta = const VerificationMeta(
    'linesPerPage',
  );
  @override
  late final GeneratedColumn<int> linesPerPage = GeneratedColumn<int>(
    'lines_per_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fontPackMeta = const VerificationMeta(
    'fontPack',
  );
  @override
  late final GeneratedColumn<String> fontPack = GeneratedColumn<String>(
    'font_pack',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    pageCount,
    linesPerPage,
    fontPack,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mushaf_layouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<MushafLayoutRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('page_count')) {
      context.handle(
        _pageCountMeta,
        pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta),
      );
    } else if (isInserting) {
      context.missing(_pageCountMeta);
    }
    if (data.containsKey('lines_per_page')) {
      context.handle(
        _linesPerPageMeta,
        linesPerPage.isAcceptableOrUnknown(
          data['lines_per_page']!,
          _linesPerPageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_linesPerPageMeta);
    }
    if (data.containsKey('font_pack')) {
      context.handle(
        _fontPackMeta,
        fontPack.isAcceptableOrUnknown(data['font_pack']!, _fontPackMeta),
      );
    } else if (isInserting) {
      context.missing(_fontPackMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MushafLayoutRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MushafLayoutRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      pageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_count'],
      )!,
      linesPerPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lines_per_page'],
      )!,
      fontPack: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}font_pack'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $MushafLayoutsTable createAlias(String alias) {
    return $MushafLayoutsTable(attachedDatabase, alias);
  }
}

class MushafLayoutRow extends DataClass implements Insertable<MushafLayoutRow> {
  final String id;
  final String name;
  final int pageCount;
  final int linesPerPage;

  /// Sayfa fontlarının paket kimliği (ör. `qcf_v2`).
  final String fontPack;
  final int version;
  const MushafLayoutRow({
    required this.id,
    required this.name,
    required this.pageCount,
    required this.linesPerPage,
    required this.fontPack,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['page_count'] = Variable<int>(pageCount);
    map['lines_per_page'] = Variable<int>(linesPerPage);
    map['font_pack'] = Variable<String>(fontPack);
    map['version'] = Variable<int>(version);
    return map;
  }

  MushafLayoutsCompanion toCompanion(bool nullToAbsent) {
    return MushafLayoutsCompanion(
      id: Value(id),
      name: Value(name),
      pageCount: Value(pageCount),
      linesPerPage: Value(linesPerPage),
      fontPack: Value(fontPack),
      version: Value(version),
    );
  }

  factory MushafLayoutRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MushafLayoutRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      pageCount: serializer.fromJson<int>(json['pageCount']),
      linesPerPage: serializer.fromJson<int>(json['linesPerPage']),
      fontPack: serializer.fromJson<String>(json['fontPack']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'pageCount': serializer.toJson<int>(pageCount),
      'linesPerPage': serializer.toJson<int>(linesPerPage),
      'fontPack': serializer.toJson<String>(fontPack),
      'version': serializer.toJson<int>(version),
    };
  }

  MushafLayoutRow copyWith({
    String? id,
    String? name,
    int? pageCount,
    int? linesPerPage,
    String? fontPack,
    int? version,
  }) => MushafLayoutRow(
    id: id ?? this.id,
    name: name ?? this.name,
    pageCount: pageCount ?? this.pageCount,
    linesPerPage: linesPerPage ?? this.linesPerPage,
    fontPack: fontPack ?? this.fontPack,
    version: version ?? this.version,
  );
  MushafLayoutRow copyWithCompanion(MushafLayoutsCompanion data) {
    return MushafLayoutRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      pageCount: data.pageCount.present ? data.pageCount.value : this.pageCount,
      linesPerPage: data.linesPerPage.present
          ? data.linesPerPage.value
          : this.linesPerPage,
      fontPack: data.fontPack.present ? data.fontPack.value : this.fontPack,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MushafLayoutRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pageCount: $pageCount, ')
          ..write('linesPerPage: $linesPerPage, ')
          ..write('fontPack: $fontPack, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, pageCount, linesPerPage, fontPack, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MushafLayoutRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.pageCount == this.pageCount &&
          other.linesPerPage == this.linesPerPage &&
          other.fontPack == this.fontPack &&
          other.version == this.version);
}

class MushafLayoutsCompanion extends UpdateCompanion<MushafLayoutRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> pageCount;
  final Value<int> linesPerPage;
  final Value<String> fontPack;
  final Value<int> version;
  final Value<int> rowid;
  const MushafLayoutsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.linesPerPage = const Value.absent(),
    this.fontPack = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MushafLayoutsCompanion.insert({
    required String id,
    required String name,
    required int pageCount,
    required int linesPerPage,
    required String fontPack,
    required int version,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       pageCount = Value(pageCount),
       linesPerPage = Value(linesPerPage),
       fontPack = Value(fontPack),
       version = Value(version);
  static Insertable<MushafLayoutRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? pageCount,
    Expression<int>? linesPerPage,
    Expression<String>? fontPack,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (pageCount != null) 'page_count': pageCount,
      if (linesPerPage != null) 'lines_per_page': linesPerPage,
      if (fontPack != null) 'font_pack': fontPack,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MushafLayoutsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? pageCount,
    Value<int>? linesPerPage,
    Value<String>? fontPack,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return MushafLayoutsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      pageCount: pageCount ?? this.pageCount,
      linesPerPage: linesPerPage ?? this.linesPerPage,
      fontPack: fontPack ?? this.fontPack,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (pageCount.present) {
      map['page_count'] = Variable<int>(pageCount.value);
    }
    if (linesPerPage.present) {
      map['lines_per_page'] = Variable<int>(linesPerPage.value);
    }
    if (fontPack.present) {
      map['font_pack'] = Variable<String>(fontPack.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MushafLayoutsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pageCount: $pageCount, ')
          ..write('linesPerPage: $linesPerPage, ')
          ..write('fontPack: $fontPack, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LayoutLinesTable extends LayoutLines
    with TableInfo<$LayoutLinesTable, LayoutLineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LayoutLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _layoutIdMeta = const VerificationMeta(
    'layoutId',
  );
  @override
  late final GeneratedColumn<String> layoutId = GeneratedColumn<String>(
    'layout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mushaf_layouts (id)',
    ),
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineMeta = const VerificationMeta('line');
  @override
  late final GeneratedColumn<int> line = GeneratedColumn<int>(
    'line',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LayoutLineType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LayoutLineType>($LayoutLinesTable.$convertertype);
  static const VerificationMeta _surahMeta = const VerificationMeta('surah');
  @override
  late final GeneratedColumn<int> surah = GeneratedColumn<int>(
    'surah',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCenteredMeta = const VerificationMeta(
    'isCentered',
  );
  @override
  late final GeneratedColumn<bool> isCentered = GeneratedColumn<bool>(
    'is_centered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_centered" IN (0, 1))',
    ),
  );
  static const VerificationMeta _firstGlyphIdMeta = const VerificationMeta(
    'firstGlyphId',
  );
  @override
  late final GeneratedColumn<int> firstGlyphId = GeneratedColumn<int>(
    'first_glyph_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastGlyphIdMeta = const VerificationMeta(
    'lastGlyphId',
  );
  @override
  late final GeneratedColumn<int> lastGlyphId = GeneratedColumn<int>(
    'last_glyph_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    layoutId,
    page,
    line,
    type,
    surah,
    isCentered,
    firstGlyphId,
    lastGlyphId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'layout_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<LayoutLineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('layout_id')) {
      context.handle(
        _layoutIdMeta,
        layoutId.isAcceptableOrUnknown(data['layout_id']!, _layoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_layoutIdMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    } else if (isInserting) {
      context.missing(_pageMeta);
    }
    if (data.containsKey('line')) {
      context.handle(
        _lineMeta,
        line.isAcceptableOrUnknown(data['line']!, _lineMeta),
      );
    } else if (isInserting) {
      context.missing(_lineMeta);
    }
    if (data.containsKey('surah')) {
      context.handle(
        _surahMeta,
        surah.isAcceptableOrUnknown(data['surah']!, _surahMeta),
      );
    }
    if (data.containsKey('is_centered')) {
      context.handle(
        _isCenteredMeta,
        isCentered.isAcceptableOrUnknown(data['is_centered']!, _isCenteredMeta),
      );
    } else if (isInserting) {
      context.missing(_isCenteredMeta);
    }
    if (data.containsKey('first_glyph_id')) {
      context.handle(
        _firstGlyphIdMeta,
        firstGlyphId.isAcceptableOrUnknown(
          data['first_glyph_id']!,
          _firstGlyphIdMeta,
        ),
      );
    }
    if (data.containsKey('last_glyph_id')) {
      context.handle(
        _lastGlyphIdMeta,
        lastGlyphId.isAcceptableOrUnknown(
          data['last_glyph_id']!,
          _lastGlyphIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {layoutId, page, line};
  @override
  LayoutLineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LayoutLineRow(
      layoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layout_id'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      )!,
      line: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line'],
      )!,
      type: $LayoutLinesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      surah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah'],
      ),
      isCentered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_centered'],
      )!,
      firstGlyphId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_glyph_id'],
      ),
      lastGlyphId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_glyph_id'],
      ),
    );
  }

  @override
  $LayoutLinesTable createAlias(String alias) {
    return $LayoutLinesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LayoutLineType, String, String> $convertertype =
      const EnumNameConverter<LayoutLineType>(LayoutLineType.values);
}

class LayoutLineRow extends DataClass implements Insertable<LayoutLineRow> {
  final String layoutId;
  final int page;
  final int line;
  final LayoutLineType type;

  /// Sure başlığı ve besmele satırlarında hangi sureye ait olduğu.
  final int? surah;

  /// Satır ortalı mı (değilse iki yana yaslı).
  final bool isCentered;

  /// Ayet satırlarında satırdaki ilk ve son glif (`LayoutGlyphs.id`).
  final int? firstGlyphId;
  final int? lastGlyphId;
  const LayoutLineRow({
    required this.layoutId,
    required this.page,
    required this.line,
    required this.type,
    this.surah,
    required this.isCentered,
    this.firstGlyphId,
    this.lastGlyphId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['layout_id'] = Variable<String>(layoutId);
    map['page'] = Variable<int>(page);
    map['line'] = Variable<int>(line);
    {
      map['type'] = Variable<String>(
        $LayoutLinesTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || surah != null) {
      map['surah'] = Variable<int>(surah);
    }
    map['is_centered'] = Variable<bool>(isCentered);
    if (!nullToAbsent || firstGlyphId != null) {
      map['first_glyph_id'] = Variable<int>(firstGlyphId);
    }
    if (!nullToAbsent || lastGlyphId != null) {
      map['last_glyph_id'] = Variable<int>(lastGlyphId);
    }
    return map;
  }

  LayoutLinesCompanion toCompanion(bool nullToAbsent) {
    return LayoutLinesCompanion(
      layoutId: Value(layoutId),
      page: Value(page),
      line: Value(line),
      type: Value(type),
      surah: surah == null && nullToAbsent
          ? const Value.absent()
          : Value(surah),
      isCentered: Value(isCentered),
      firstGlyphId: firstGlyphId == null && nullToAbsent
          ? const Value.absent()
          : Value(firstGlyphId),
      lastGlyphId: lastGlyphId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastGlyphId),
    );
  }

  factory LayoutLineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LayoutLineRow(
      layoutId: serializer.fromJson<String>(json['layoutId']),
      page: serializer.fromJson<int>(json['page']),
      line: serializer.fromJson<int>(json['line']),
      type: $LayoutLinesTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      surah: serializer.fromJson<int?>(json['surah']),
      isCentered: serializer.fromJson<bool>(json['isCentered']),
      firstGlyphId: serializer.fromJson<int?>(json['firstGlyphId']),
      lastGlyphId: serializer.fromJson<int?>(json['lastGlyphId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'layoutId': serializer.toJson<String>(layoutId),
      'page': serializer.toJson<int>(page),
      'line': serializer.toJson<int>(line),
      'type': serializer.toJson<String>(
        $LayoutLinesTable.$convertertype.toJson(type),
      ),
      'surah': serializer.toJson<int?>(surah),
      'isCentered': serializer.toJson<bool>(isCentered),
      'firstGlyphId': serializer.toJson<int?>(firstGlyphId),
      'lastGlyphId': serializer.toJson<int?>(lastGlyphId),
    };
  }

  LayoutLineRow copyWith({
    String? layoutId,
    int? page,
    int? line,
    LayoutLineType? type,
    Value<int?> surah = const Value.absent(),
    bool? isCentered,
    Value<int?> firstGlyphId = const Value.absent(),
    Value<int?> lastGlyphId = const Value.absent(),
  }) => LayoutLineRow(
    layoutId: layoutId ?? this.layoutId,
    page: page ?? this.page,
    line: line ?? this.line,
    type: type ?? this.type,
    surah: surah.present ? surah.value : this.surah,
    isCentered: isCentered ?? this.isCentered,
    firstGlyphId: firstGlyphId.present ? firstGlyphId.value : this.firstGlyphId,
    lastGlyphId: lastGlyphId.present ? lastGlyphId.value : this.lastGlyphId,
  );
  LayoutLineRow copyWithCompanion(LayoutLinesCompanion data) {
    return LayoutLineRow(
      layoutId: data.layoutId.present ? data.layoutId.value : this.layoutId,
      page: data.page.present ? data.page.value : this.page,
      line: data.line.present ? data.line.value : this.line,
      type: data.type.present ? data.type.value : this.type,
      surah: data.surah.present ? data.surah.value : this.surah,
      isCentered: data.isCentered.present
          ? data.isCentered.value
          : this.isCentered,
      firstGlyphId: data.firstGlyphId.present
          ? data.firstGlyphId.value
          : this.firstGlyphId,
      lastGlyphId: data.lastGlyphId.present
          ? data.lastGlyphId.value
          : this.lastGlyphId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LayoutLineRow(')
          ..write('layoutId: $layoutId, ')
          ..write('page: $page, ')
          ..write('line: $line, ')
          ..write('type: $type, ')
          ..write('surah: $surah, ')
          ..write('isCentered: $isCentered, ')
          ..write('firstGlyphId: $firstGlyphId, ')
          ..write('lastGlyphId: $lastGlyphId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    layoutId,
    page,
    line,
    type,
    surah,
    isCentered,
    firstGlyphId,
    lastGlyphId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LayoutLineRow &&
          other.layoutId == this.layoutId &&
          other.page == this.page &&
          other.line == this.line &&
          other.type == this.type &&
          other.surah == this.surah &&
          other.isCentered == this.isCentered &&
          other.firstGlyphId == this.firstGlyphId &&
          other.lastGlyphId == this.lastGlyphId);
}

class LayoutLinesCompanion extends UpdateCompanion<LayoutLineRow> {
  final Value<String> layoutId;
  final Value<int> page;
  final Value<int> line;
  final Value<LayoutLineType> type;
  final Value<int?> surah;
  final Value<bool> isCentered;
  final Value<int?> firstGlyphId;
  final Value<int?> lastGlyphId;
  final Value<int> rowid;
  const LayoutLinesCompanion({
    this.layoutId = const Value.absent(),
    this.page = const Value.absent(),
    this.line = const Value.absent(),
    this.type = const Value.absent(),
    this.surah = const Value.absent(),
    this.isCentered = const Value.absent(),
    this.firstGlyphId = const Value.absent(),
    this.lastGlyphId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LayoutLinesCompanion.insert({
    required String layoutId,
    required int page,
    required int line,
    required LayoutLineType type,
    this.surah = const Value.absent(),
    required bool isCentered,
    this.firstGlyphId = const Value.absent(),
    this.lastGlyphId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : layoutId = Value(layoutId),
       page = Value(page),
       line = Value(line),
       type = Value(type),
       isCentered = Value(isCentered);
  static Insertable<LayoutLineRow> custom({
    Expression<String>? layoutId,
    Expression<int>? page,
    Expression<int>? line,
    Expression<String>? type,
    Expression<int>? surah,
    Expression<bool>? isCentered,
    Expression<int>? firstGlyphId,
    Expression<int>? lastGlyphId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (layoutId != null) 'layout_id': layoutId,
      if (page != null) 'page': page,
      if (line != null) 'line': line,
      if (type != null) 'type': type,
      if (surah != null) 'surah': surah,
      if (isCentered != null) 'is_centered': isCentered,
      if (firstGlyphId != null) 'first_glyph_id': firstGlyphId,
      if (lastGlyphId != null) 'last_glyph_id': lastGlyphId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LayoutLinesCompanion copyWith({
    Value<String>? layoutId,
    Value<int>? page,
    Value<int>? line,
    Value<LayoutLineType>? type,
    Value<int?>? surah,
    Value<bool>? isCentered,
    Value<int?>? firstGlyphId,
    Value<int?>? lastGlyphId,
    Value<int>? rowid,
  }) {
    return LayoutLinesCompanion(
      layoutId: layoutId ?? this.layoutId,
      page: page ?? this.page,
      line: line ?? this.line,
      type: type ?? this.type,
      surah: surah ?? this.surah,
      isCentered: isCentered ?? this.isCentered,
      firstGlyphId: firstGlyphId ?? this.firstGlyphId,
      lastGlyphId: lastGlyphId ?? this.lastGlyphId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (layoutId.present) {
      map['layout_id'] = Variable<String>(layoutId.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (line.present) {
      map['line'] = Variable<int>(line.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $LayoutLinesTable.$convertertype.toSql(type.value),
      );
    }
    if (surah.present) {
      map['surah'] = Variable<int>(surah.value);
    }
    if (isCentered.present) {
      map['is_centered'] = Variable<bool>(isCentered.value);
    }
    if (firstGlyphId.present) {
      map['first_glyph_id'] = Variable<int>(firstGlyphId.value);
    }
    if (lastGlyphId.present) {
      map['last_glyph_id'] = Variable<int>(lastGlyphId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LayoutLinesCompanion(')
          ..write('layoutId: $layoutId, ')
          ..write('page: $page, ')
          ..write('line: $line, ')
          ..write('type: $type, ')
          ..write('surah: $surah, ')
          ..write('isCentered: $isCentered, ')
          ..write('firstGlyphId: $firstGlyphId, ')
          ..write('lastGlyphId: $lastGlyphId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LayoutPagesTable extends LayoutPages
    with TableInfo<$LayoutPagesTable, LayoutPageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LayoutPagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _layoutIdMeta = const VerificationMeta(
    'layoutId',
  );
  @override
  late final GeneratedColumn<String> layoutId = GeneratedColumn<String>(
    'layout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mushaf_layouts (id)',
    ),
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstAyahIdMeta = const VerificationMeta(
    'firstAyahId',
  );
  @override
  late final GeneratedColumn<int> firstAyahId = GeneratedColumn<int>(
    'first_ayah_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastAyahIdMeta = const VerificationMeta(
    'lastAyahId',
  );
  @override
  late final GeneratedColumn<int> lastAyahId = GeneratedColumn<int>(
    'last_ayah_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    layoutId,
    page,
    firstAyahId,
    lastAyahId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'layout_pages';
  @override
  VerificationContext validateIntegrity(
    Insertable<LayoutPageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('layout_id')) {
      context.handle(
        _layoutIdMeta,
        layoutId.isAcceptableOrUnknown(data['layout_id']!, _layoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_layoutIdMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    } else if (isInserting) {
      context.missing(_pageMeta);
    }
    if (data.containsKey('first_ayah_id')) {
      context.handle(
        _firstAyahIdMeta,
        firstAyahId.isAcceptableOrUnknown(
          data['first_ayah_id']!,
          _firstAyahIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstAyahIdMeta);
    }
    if (data.containsKey('last_ayah_id')) {
      context.handle(
        _lastAyahIdMeta,
        lastAyahId.isAcceptableOrUnknown(
          data['last_ayah_id']!,
          _lastAyahIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastAyahIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {layoutId, page};
  @override
  LayoutPageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LayoutPageRow(
      layoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layout_id'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      )!,
      firstAyahId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_ayah_id'],
      )!,
      lastAyahId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_ayah_id'],
      )!,
    );
  }

  @override
  $LayoutPagesTable createAlias(String alias) {
    return $LayoutPagesTable(attachedDatabase, alias);
  }
}

class LayoutPageRow extends DataClass implements Insertable<LayoutPageRow> {
  final String layoutId;
  final int page;
  final int firstAyahId;
  final int lastAyahId;
  const LayoutPageRow({
    required this.layoutId,
    required this.page,
    required this.firstAyahId,
    required this.lastAyahId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['layout_id'] = Variable<String>(layoutId);
    map['page'] = Variable<int>(page);
    map['first_ayah_id'] = Variable<int>(firstAyahId);
    map['last_ayah_id'] = Variable<int>(lastAyahId);
    return map;
  }

  LayoutPagesCompanion toCompanion(bool nullToAbsent) {
    return LayoutPagesCompanion(
      layoutId: Value(layoutId),
      page: Value(page),
      firstAyahId: Value(firstAyahId),
      lastAyahId: Value(lastAyahId),
    );
  }

  factory LayoutPageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LayoutPageRow(
      layoutId: serializer.fromJson<String>(json['layoutId']),
      page: serializer.fromJson<int>(json['page']),
      firstAyahId: serializer.fromJson<int>(json['firstAyahId']),
      lastAyahId: serializer.fromJson<int>(json['lastAyahId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'layoutId': serializer.toJson<String>(layoutId),
      'page': serializer.toJson<int>(page),
      'firstAyahId': serializer.toJson<int>(firstAyahId),
      'lastAyahId': serializer.toJson<int>(lastAyahId),
    };
  }

  LayoutPageRow copyWith({
    String? layoutId,
    int? page,
    int? firstAyahId,
    int? lastAyahId,
  }) => LayoutPageRow(
    layoutId: layoutId ?? this.layoutId,
    page: page ?? this.page,
    firstAyahId: firstAyahId ?? this.firstAyahId,
    lastAyahId: lastAyahId ?? this.lastAyahId,
  );
  LayoutPageRow copyWithCompanion(LayoutPagesCompanion data) {
    return LayoutPageRow(
      layoutId: data.layoutId.present ? data.layoutId.value : this.layoutId,
      page: data.page.present ? data.page.value : this.page,
      firstAyahId: data.firstAyahId.present
          ? data.firstAyahId.value
          : this.firstAyahId,
      lastAyahId: data.lastAyahId.present
          ? data.lastAyahId.value
          : this.lastAyahId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LayoutPageRow(')
          ..write('layoutId: $layoutId, ')
          ..write('page: $page, ')
          ..write('firstAyahId: $firstAyahId, ')
          ..write('lastAyahId: $lastAyahId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(layoutId, page, firstAyahId, lastAyahId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LayoutPageRow &&
          other.layoutId == this.layoutId &&
          other.page == this.page &&
          other.firstAyahId == this.firstAyahId &&
          other.lastAyahId == this.lastAyahId);
}

class LayoutPagesCompanion extends UpdateCompanion<LayoutPageRow> {
  final Value<String> layoutId;
  final Value<int> page;
  final Value<int> firstAyahId;
  final Value<int> lastAyahId;
  final Value<int> rowid;
  const LayoutPagesCompanion({
    this.layoutId = const Value.absent(),
    this.page = const Value.absent(),
    this.firstAyahId = const Value.absent(),
    this.lastAyahId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LayoutPagesCompanion.insert({
    required String layoutId,
    required int page,
    required int firstAyahId,
    required int lastAyahId,
    this.rowid = const Value.absent(),
  }) : layoutId = Value(layoutId),
       page = Value(page),
       firstAyahId = Value(firstAyahId),
       lastAyahId = Value(lastAyahId);
  static Insertable<LayoutPageRow> custom({
    Expression<String>? layoutId,
    Expression<int>? page,
    Expression<int>? firstAyahId,
    Expression<int>? lastAyahId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (layoutId != null) 'layout_id': layoutId,
      if (page != null) 'page': page,
      if (firstAyahId != null) 'first_ayah_id': firstAyahId,
      if (lastAyahId != null) 'last_ayah_id': lastAyahId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LayoutPagesCompanion copyWith({
    Value<String>? layoutId,
    Value<int>? page,
    Value<int>? firstAyahId,
    Value<int>? lastAyahId,
    Value<int>? rowid,
  }) {
    return LayoutPagesCompanion(
      layoutId: layoutId ?? this.layoutId,
      page: page ?? this.page,
      firstAyahId: firstAyahId ?? this.firstAyahId,
      lastAyahId: lastAyahId ?? this.lastAyahId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (layoutId.present) {
      map['layout_id'] = Variable<String>(layoutId.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (firstAyahId.present) {
      map['first_ayah_id'] = Variable<int>(firstAyahId.value);
    }
    if (lastAyahId.present) {
      map['last_ayah_id'] = Variable<int>(lastAyahId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LayoutPagesCompanion(')
          ..write('layoutId: $layoutId, ')
          ..write('page: $page, ')
          ..write('firstAyahId: $firstAyahId, ')
          ..write('lastAyahId: $lastAyahId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LayoutGlyphsTable extends LayoutGlyphs
    with TableInfo<$LayoutGlyphsTable, LayoutGlyphRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LayoutGlyphsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _layoutIdMeta = const VerificationMeta(
    'layoutId',
  );
  @override
  late final GeneratedColumn<String> layoutId = GeneratedColumn<String>(
    'layout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mushaf_layouts (id)',
    ),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstWordIdMeta = const VerificationMeta(
    'firstWordId',
  );
  @override
  late final GeneratedColumn<int> firstWordId = GeneratedColumn<int>(
    'first_word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words (id)',
    ),
  );
  static const VerificationMeta _lastWordIdMeta = const VerificationMeta(
    'lastWordId',
  );
  @override
  late final GeneratedColumn<int> lastWordId = GeneratedColumn<int>(
    'last_word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words (id)',
    ),
  );
  static const VerificationMeta _glyphMeta = const VerificationMeta('glyph');
  @override
  late final GeneratedColumn<String> glyph = GeneratedColumn<String>(
    'glyph',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _digitalKhattTextMeta = const VerificationMeta(
    'digitalKhattText',
  );
  @override
  late final GeneratedColumn<String> digitalKhattText = GeneratedColumn<String>(
    'digital_khatt_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    layoutId,
    id,
    firstWordId,
    lastWordId,
    glyph,
    digitalKhattText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'layout_glyphs';
  @override
  VerificationContext validateIntegrity(
    Insertable<LayoutGlyphRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('layout_id')) {
      context.handle(
        _layoutIdMeta,
        layoutId.isAcceptableOrUnknown(data['layout_id']!, _layoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_layoutIdMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('first_word_id')) {
      context.handle(
        _firstWordIdMeta,
        firstWordId.isAcceptableOrUnknown(
          data['first_word_id']!,
          _firstWordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstWordIdMeta);
    }
    if (data.containsKey('last_word_id')) {
      context.handle(
        _lastWordIdMeta,
        lastWordId.isAcceptableOrUnknown(
          data['last_word_id']!,
          _lastWordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastWordIdMeta);
    }
    if (data.containsKey('glyph')) {
      context.handle(
        _glyphMeta,
        glyph.isAcceptableOrUnknown(data['glyph']!, _glyphMeta),
      );
    } else if (isInserting) {
      context.missing(_glyphMeta);
    }
    if (data.containsKey('digital_khatt_text')) {
      context.handle(
        _digitalKhattTextMeta,
        digitalKhattText.isAcceptableOrUnknown(
          data['digital_khatt_text']!,
          _digitalKhattTextMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {layoutId, id};
  @override
  LayoutGlyphRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LayoutGlyphRow(
      layoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layout_id'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      firstWordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_word_id'],
      )!,
      lastWordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_word_id'],
      )!,
      glyph: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}glyph'],
      )!,
      digitalKhattText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}digital_khatt_text'],
      ),
    );
  }

  @override
  $LayoutGlyphsTable createAlias(String alias) {
    return $LayoutGlyphsTable(attachedDatabase, alias);
  }
}

class LayoutGlyphRow extends DataClass implements Insertable<LayoutGlyphRow> {
  final String layoutId;
  final int id;
  final int firstWordId;
  final int lastWordId;

  /// Sayfa fontundaki (QCF V2) karakter kodu.
  final String glyph;

  /// Aynı birimin DigitalKhatt yazılışı (DigitalKhatt fontuyla çizilir).
  final String? digitalKhattText;
  const LayoutGlyphRow({
    required this.layoutId,
    required this.id,
    required this.firstWordId,
    required this.lastWordId,
    required this.glyph,
    this.digitalKhattText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['layout_id'] = Variable<String>(layoutId);
    map['id'] = Variable<int>(id);
    map['first_word_id'] = Variable<int>(firstWordId);
    map['last_word_id'] = Variable<int>(lastWordId);
    map['glyph'] = Variable<String>(glyph);
    if (!nullToAbsent || digitalKhattText != null) {
      map['digital_khatt_text'] = Variable<String>(digitalKhattText);
    }
    return map;
  }

  LayoutGlyphsCompanion toCompanion(bool nullToAbsent) {
    return LayoutGlyphsCompanion(
      layoutId: Value(layoutId),
      id: Value(id),
      firstWordId: Value(firstWordId),
      lastWordId: Value(lastWordId),
      glyph: Value(glyph),
      digitalKhattText: digitalKhattText == null && nullToAbsent
          ? const Value.absent()
          : Value(digitalKhattText),
    );
  }

  factory LayoutGlyphRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LayoutGlyphRow(
      layoutId: serializer.fromJson<String>(json['layoutId']),
      id: serializer.fromJson<int>(json['id']),
      firstWordId: serializer.fromJson<int>(json['firstWordId']),
      lastWordId: serializer.fromJson<int>(json['lastWordId']),
      glyph: serializer.fromJson<String>(json['glyph']),
      digitalKhattText: serializer.fromJson<String?>(json['digitalKhattText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'layoutId': serializer.toJson<String>(layoutId),
      'id': serializer.toJson<int>(id),
      'firstWordId': serializer.toJson<int>(firstWordId),
      'lastWordId': serializer.toJson<int>(lastWordId),
      'glyph': serializer.toJson<String>(glyph),
      'digitalKhattText': serializer.toJson<String?>(digitalKhattText),
    };
  }

  LayoutGlyphRow copyWith({
    String? layoutId,
    int? id,
    int? firstWordId,
    int? lastWordId,
    String? glyph,
    Value<String?> digitalKhattText = const Value.absent(),
  }) => LayoutGlyphRow(
    layoutId: layoutId ?? this.layoutId,
    id: id ?? this.id,
    firstWordId: firstWordId ?? this.firstWordId,
    lastWordId: lastWordId ?? this.lastWordId,
    glyph: glyph ?? this.glyph,
    digitalKhattText: digitalKhattText.present
        ? digitalKhattText.value
        : this.digitalKhattText,
  );
  LayoutGlyphRow copyWithCompanion(LayoutGlyphsCompanion data) {
    return LayoutGlyphRow(
      layoutId: data.layoutId.present ? data.layoutId.value : this.layoutId,
      id: data.id.present ? data.id.value : this.id,
      firstWordId: data.firstWordId.present
          ? data.firstWordId.value
          : this.firstWordId,
      lastWordId: data.lastWordId.present
          ? data.lastWordId.value
          : this.lastWordId,
      glyph: data.glyph.present ? data.glyph.value : this.glyph,
      digitalKhattText: data.digitalKhattText.present
          ? data.digitalKhattText.value
          : this.digitalKhattText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LayoutGlyphRow(')
          ..write('layoutId: $layoutId, ')
          ..write('id: $id, ')
          ..write('firstWordId: $firstWordId, ')
          ..write('lastWordId: $lastWordId, ')
          ..write('glyph: $glyph, ')
          ..write('digitalKhattText: $digitalKhattText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    layoutId,
    id,
    firstWordId,
    lastWordId,
    glyph,
    digitalKhattText,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LayoutGlyphRow &&
          other.layoutId == this.layoutId &&
          other.id == this.id &&
          other.firstWordId == this.firstWordId &&
          other.lastWordId == this.lastWordId &&
          other.glyph == this.glyph &&
          other.digitalKhattText == this.digitalKhattText);
}

class LayoutGlyphsCompanion extends UpdateCompanion<LayoutGlyphRow> {
  final Value<String> layoutId;
  final Value<int> id;
  final Value<int> firstWordId;
  final Value<int> lastWordId;
  final Value<String> glyph;
  final Value<String?> digitalKhattText;
  final Value<int> rowid;
  const LayoutGlyphsCompanion({
    this.layoutId = const Value.absent(),
    this.id = const Value.absent(),
    this.firstWordId = const Value.absent(),
    this.lastWordId = const Value.absent(),
    this.glyph = const Value.absent(),
    this.digitalKhattText = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LayoutGlyphsCompanion.insert({
    required String layoutId,
    required int id,
    required int firstWordId,
    required int lastWordId,
    required String glyph,
    this.digitalKhattText = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : layoutId = Value(layoutId),
       id = Value(id),
       firstWordId = Value(firstWordId),
       lastWordId = Value(lastWordId),
       glyph = Value(glyph);
  static Insertable<LayoutGlyphRow> custom({
    Expression<String>? layoutId,
    Expression<int>? id,
    Expression<int>? firstWordId,
    Expression<int>? lastWordId,
    Expression<String>? glyph,
    Expression<String>? digitalKhattText,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (layoutId != null) 'layout_id': layoutId,
      if (id != null) 'id': id,
      if (firstWordId != null) 'first_word_id': firstWordId,
      if (lastWordId != null) 'last_word_id': lastWordId,
      if (glyph != null) 'glyph': glyph,
      if (digitalKhattText != null) 'digital_khatt_text': digitalKhattText,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LayoutGlyphsCompanion copyWith({
    Value<String>? layoutId,
    Value<int>? id,
    Value<int>? firstWordId,
    Value<int>? lastWordId,
    Value<String>? glyph,
    Value<String?>? digitalKhattText,
    Value<int>? rowid,
  }) {
    return LayoutGlyphsCompanion(
      layoutId: layoutId ?? this.layoutId,
      id: id ?? this.id,
      firstWordId: firstWordId ?? this.firstWordId,
      lastWordId: lastWordId ?? this.lastWordId,
      glyph: glyph ?? this.glyph,
      digitalKhattText: digitalKhattText ?? this.digitalKhattText,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (layoutId.present) {
      map['layout_id'] = Variable<String>(layoutId.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstWordId.present) {
      map['first_word_id'] = Variable<int>(firstWordId.value);
    }
    if (lastWordId.present) {
      map['last_word_id'] = Variable<int>(lastWordId.value);
    }
    if (glyph.present) {
      map['glyph'] = Variable<String>(glyph.value);
    }
    if (digitalKhattText.present) {
      map['digital_khatt_text'] = Variable<String>(digitalKhattText.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LayoutGlyphsCompanion(')
          ..write('layoutId: $layoutId, ')
          ..write('id: $id, ')
          ..write('firstWordId: $firstWordId, ')
          ..write('lastWordId: $lastWordId, ')
          ..write('glyph: $glyph, ')
          ..write('digitalKhattText: $digitalKhattText, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ContentDatabase extends GeneratedDatabase {
  _$ContentDatabase(QueryExecutor e) : super(e);
  $ContentDatabaseManager get managers => $ContentDatabaseManager(this);
  late final $ContentMetaTable contentMeta = $ContentMetaTable(this);
  late final $SurahsTable surahs = $SurahsTable(this);
  late final $AyahsTable ayahs = $AyahsTable(this);
  late final $WordsTable words = $WordsTable(this);
  late final $MushafLayoutsTable mushafLayouts = $MushafLayoutsTable(this);
  late final $LayoutLinesTable layoutLines = $LayoutLinesTable(this);
  late final $LayoutPagesTable layoutPages = $LayoutPagesTable(this);
  late final $LayoutGlyphsTable layoutGlyphs = $LayoutGlyphsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    contentMeta,
    surahs,
    ayahs,
    words,
    mushafLayouts,
    layoutLines,
    layoutPages,
    layoutGlyphs,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ContentMetaTableCreateCompanionBuilder =
    ContentMetaCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$ContentMetaTableUpdateCompanionBuilder =
    ContentMetaCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$ContentMetaTableFilterComposer
    extends Composer<_$ContentDatabase, $ContentMetaTable> {
  $$ContentMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentMetaTableOrderingComposer
    extends Composer<_$ContentDatabase, $ContentMetaTable> {
  $$ContentMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentMetaTableAnnotationComposer
    extends Composer<_$ContentDatabase, $ContentMetaTable> {
  $$ContentMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$ContentMetaTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $ContentMetaTable,
          ContentMetaData,
          $$ContentMetaTableFilterComposer,
          $$ContentMetaTableOrderingComposer,
          $$ContentMetaTableAnnotationComposer,
          $$ContentMetaTableCreateCompanionBuilder,
          $$ContentMetaTableUpdateCompanionBuilder,
          (
            ContentMetaData,
            BaseReferences<
              _$ContentDatabase,
              $ContentMetaTable,
              ContentMetaData
            >,
          ),
          ContentMetaData,
          PrefetchHooks Function()
        > {
  $$ContentMetaTableTableManager(_$ContentDatabase db, $ContentMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => ContentMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => ContentMetaCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContentMetaTable, ContentMetaData>(table),
                  BaseReferences<
                    _$ContentDatabase,
                    $ContentMetaTable,
                    ContentMetaData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $ContentMetaTable,
      ContentMetaData,
      $$ContentMetaTableFilterComposer,
      $$ContentMetaTableOrderingComposer,
      $$ContentMetaTableAnnotationComposer,
      $$ContentMetaTableCreateCompanionBuilder,
      $$ContentMetaTableUpdateCompanionBuilder,
      (
        ContentMetaData,
        BaseReferences<_$ContentDatabase, $ContentMetaTable, ContentMetaData>,
      ),
      ContentMetaData,
      PrefetchHooks Function()
    >;
typedef $$SurahsTableCreateCompanionBuilder = SurahsCompanion Function({
  Value<int> id,
  required String nameArabic,
  required String nameSimple,
  required String nameTr,
  required String nameEn,
  required RevelationPlace revelationPlace,
  required int revelationOrder,
  required bool bismillahPre,
  required int ayahCount,
});
typedef $$SurahsTableUpdateCompanionBuilder = SurahsCompanion Function({
  Value<int> id,
  Value<String> nameArabic,
  Value<String> nameSimple,
  Value<String> nameTr,
  Value<String> nameEn,
  Value<RevelationPlace> revelationPlace,
  Value<int> revelationOrder,
  Value<bool> bismillahPre,
  Value<int> ayahCount,
});

final class $$SurahsTableReferences
    extends BaseReferences<_$ContentDatabase, $SurahsTable, SurahRow> {
  $$SurahsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AyahsTable, List<AyahRow>> _ayahsRefsTable(
    _$ContentDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ayahs,
    aliasName: 'surahs__id__ayahs__surah',
  );

  $$AyahsTableProcessedTableManager get ayahsRefs {
    final manager = $$AyahsTableTableManager(
      $_db,
      $_db.ayahs,
    ).filter((f) => f.surah.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ayahsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SurahsTableFilterComposer
    extends Composer<_$ContentDatabase, $SurahsTable> {
  $$SurahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameSimple => $composableBuilder(
    column: $table.nameSimple,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameTr => $composableBuilder(
    column: $table.nameTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RevelationPlace, RevelationPlace, String>
  get revelationPlace => $composableBuilder(
    column: $table.revelationPlace,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get revelationOrder => $composableBuilder(
    column: $table.revelationOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get bismillahPre => $composableBuilder(
    column: $table.bismillahPre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahCount => $composableBuilder(
    column: $table.ayahCount,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ayahsRefs(
    Expression<bool> Function($$AyahsTableFilterComposer f) f,
  ) {
    final $$AyahsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ayahs,
      getReferencedColumn: (t) => t.surah,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AyahsTableFilterComposer(
            $db: $db,
            $table: $db.ayahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SurahsTableOrderingComposer
    extends Composer<_$ContentDatabase, $SurahsTable> {
  $$SurahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameSimple => $composableBuilder(
    column: $table.nameSimple,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameTr => $composableBuilder(
    column: $table.nameTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revelationPlace => $composableBuilder(
    column: $table.revelationPlace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revelationOrder => $composableBuilder(
    column: $table.revelationOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get bismillahPre => $composableBuilder(
    column: $table.bismillahPre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahCount => $composableBuilder(
    column: $table.ayahCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SurahsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $SurahsTable> {
  $$SurahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameSimple => $composableBuilder(
    column: $table.nameSimple,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameTr =>
      $composableBuilder(column: $table.nameTr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RevelationPlace, String>
  get revelationPlace => $composableBuilder(
    column: $table.revelationPlace,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revelationOrder => $composableBuilder(
    column: $table.revelationOrder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get bismillahPre => $composableBuilder(
    column: $table.bismillahPre,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahCount =>
      $composableBuilder(column: $table.ayahCount, builder: (column) => column);

  Expression<T> ayahsRefs<T extends Object>(
    Expression<T> Function($$AyahsTableAnnotationComposer a) f,
  ) {
    final $$AyahsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ayahs,
      getReferencedColumn: (t) => t.surah,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AyahsTableAnnotationComposer(
            $db: $db,
            $table: $db.ayahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SurahsTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $SurahsTable,
          SurahRow,
          $$SurahsTableFilterComposer,
          $$SurahsTableOrderingComposer,
          $$SurahsTableAnnotationComposer,
          $$SurahsTableCreateCompanionBuilder,
          $$SurahsTableUpdateCompanionBuilder,
          (SurahRow, $$SurahsTableReferences),
          SurahRow,
          PrefetchHooks Function({bool ayahsRefs})
        > {
  $$SurahsTableTableManager(_$ContentDatabase db, $SurahsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SurahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameArabic = const Value.absent(),
                Value<String> nameSimple = const Value.absent(),
                Value<String> nameTr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<RevelationPlace> revelationPlace = const Value.absent(),
                Value<int> revelationOrder = const Value.absent(),
                Value<bool> bismillahPre = const Value.absent(),
                Value<int> ayahCount = const Value.absent(),
              }) => SurahsCompanion(
                id: id,
                nameArabic: nameArabic,
                nameSimple: nameSimple,
                nameTr: nameTr,
                nameEn: nameEn,
                revelationPlace: revelationPlace,
                revelationOrder: revelationOrder,
                bismillahPre: bismillahPre,
                ayahCount: ayahCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameArabic,
                required String nameSimple,
                required String nameTr,
                required String nameEn,
                required RevelationPlace revelationPlace,
                required int revelationOrder,
                required bool bismillahPre,
                required int ayahCount,
              }) => SurahsCompanion.insert(
                id: id,
                nameArabic: nameArabic,
                nameSimple: nameSimple,
                nameTr: nameTr,
                nameEn: nameEn,
                revelationPlace: revelationPlace,
                revelationOrder: revelationOrder,
                bismillahPre: bismillahPre,
                ayahCount: ayahCount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SurahsTable, SurahRow>(table),
                  $$SurahsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ayahsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ayahsRefs) db.ayahs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ayahsRefs)
                    await $_getPrefetchedDataByColumns<
                      SurahRow,
                      $SurahsTable,
                      AyahRow,
                      $AyahsTable
                    >(
                      currentTable: table,
                      referencedTable: $$SurahsTableReferences._ayahsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$SurahsTableReferences(db, table, p0).ayahsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'surah',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SurahsTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $SurahsTable,
      SurahRow,
      $$SurahsTableFilterComposer,
      $$SurahsTableOrderingComposer,
      $$SurahsTableAnnotationComposer,
      $$SurahsTableCreateCompanionBuilder,
      $$SurahsTableUpdateCompanionBuilder,
      (SurahRow, $$SurahsTableReferences),
      SurahRow,
      PrefetchHooks Function({bool ayahsRefs})
    >;
typedef $$AyahsTableCreateCompanionBuilder = AyahsCompanion Function({
  Value<int> id,
  required int surah,
  required int ayah,
  required int juz,
  required int hizb,
  required int rub,
  Value<int?> sajdah,
  required String textUthmani,
  required String textQpcHafs,
  required String textDigitalKhatt,
});
typedef $$AyahsTableUpdateCompanionBuilder = AyahsCompanion Function({
  Value<int> id,
  Value<int> surah,
  Value<int> ayah,
  Value<int> juz,
  Value<int> hizb,
  Value<int> rub,
  Value<int?> sajdah,
  Value<String> textUthmani,
  Value<String> textQpcHafs,
  Value<String> textDigitalKhatt,
});

final class $$AyahsTableReferences
    extends BaseReferences<_$ContentDatabase, $AyahsTable, AyahRow> {
  $$AyahsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SurahsTable _surahTable(_$ContentDatabase db) =>
      db.surahs.createAlias('ayahs__surah__surahs__id');

  $$SurahsTableProcessedTableManager get surah {
    final $_column = $_itemColumn<int>('surah')!;

    final manager = $$SurahsTableTableManager(
      $_db,
      $_db.surahs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_surahTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WordsTable, List<WordRow>> _wordsRefsTable(
    _$ContentDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.words,
    aliasName: 'ayahs__id__words__ayah_id',
  );

  $$WordsTableProcessedTableManager get wordsRefs {
    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.ayahId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_wordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AyahsTableFilterComposer
    extends Composer<_$ContentDatabase, $AyahsTable> {
  $$AyahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayah => $composableBuilder(
    column: $table.ayah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get juz => $composableBuilder(
    column: $table.juz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hizb => $composableBuilder(
    column: $table.hizb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rub => $composableBuilder(
    column: $table.rub,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sajdah => $composableBuilder(
    column: $table.sajdah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textUthmani => $composableBuilder(
    column: $table.textUthmani,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textQpcHafs => $composableBuilder(
    column: $table.textQpcHafs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textDigitalKhatt => $composableBuilder(
    column: $table.textDigitalKhatt,
    builder: (column) => ColumnFilters(column),
  );

  $$SurahsTableFilterComposer get surah {
    final $$SurahsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surah,
      referencedTable: $db.surahs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurahsTableFilterComposer(
            $db: $db,
            $table: $db.surahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> wordsRefs(
    Expression<bool> Function($$WordsTableFilterComposer f) f,
  ) {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.ayahId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AyahsTableOrderingComposer
    extends Composer<_$ContentDatabase, $AyahsTable> {
  $$AyahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayah => $composableBuilder(
    column: $table.ayah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get juz => $composableBuilder(
    column: $table.juz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hizb => $composableBuilder(
    column: $table.hizb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rub => $composableBuilder(
    column: $table.rub,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sajdah => $composableBuilder(
    column: $table.sajdah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textUthmani => $composableBuilder(
    column: $table.textUthmani,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textQpcHafs => $composableBuilder(
    column: $table.textQpcHafs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textDigitalKhatt => $composableBuilder(
    column: $table.textDigitalKhatt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SurahsTableOrderingComposer get surah {
    final $$SurahsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surah,
      referencedTable: $db.surahs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurahsTableOrderingComposer(
            $db: $db,
            $table: $db.surahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AyahsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $AyahsTable> {
  $$AyahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ayah =>
      $composableBuilder(column: $table.ayah, builder: (column) => column);

  GeneratedColumn<int> get juz =>
      $composableBuilder(column: $table.juz, builder: (column) => column);

  GeneratedColumn<int> get hizb =>
      $composableBuilder(column: $table.hizb, builder: (column) => column);

  GeneratedColumn<int> get rub =>
      $composableBuilder(column: $table.rub, builder: (column) => column);

  GeneratedColumn<int> get sajdah =>
      $composableBuilder(column: $table.sajdah, builder: (column) => column);

  GeneratedColumn<String> get textUthmani => $composableBuilder(
    column: $table.textUthmani,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textQpcHafs => $composableBuilder(
    column: $table.textQpcHafs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textDigitalKhatt => $composableBuilder(
    column: $table.textDigitalKhatt,
    builder: (column) => column,
  );

  $$SurahsTableAnnotationComposer get surah {
    final $$SurahsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surah,
      referencedTable: $db.surahs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurahsTableAnnotationComposer(
            $db: $db,
            $table: $db.surahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> wordsRefs<T extends Object>(
    Expression<T> Function($$WordsTableAnnotationComposer a) f,
  ) {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.ayahId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AyahsTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $AyahsTable,
          AyahRow,
          $$AyahsTableFilterComposer,
          $$AyahsTableOrderingComposer,
          $$AyahsTableAnnotationComposer,
          $$AyahsTableCreateCompanionBuilder,
          $$AyahsTableUpdateCompanionBuilder,
          (AyahRow, $$AyahsTableReferences),
          AyahRow,
          PrefetchHooks Function({bool surah, bool wordsRefs})
        > {
  $$AyahsTableTableManager(_$ContentDatabase db, $AyahsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AyahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AyahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AyahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surah = const Value.absent(),
                Value<int> ayah = const Value.absent(),
                Value<int> juz = const Value.absent(),
                Value<int> hizb = const Value.absent(),
                Value<int> rub = const Value.absent(),
                Value<int?> sajdah = const Value.absent(),
                Value<String> textUthmani = const Value.absent(),
                Value<String> textQpcHafs = const Value.absent(),
                Value<String> textDigitalKhatt = const Value.absent(),
              }) => AyahsCompanion(
                id: id,
                surah: surah,
                ayah: ayah,
                juz: juz,
                hizb: hizb,
                rub: rub,
                sajdah: sajdah,
                textUthmani: textUthmani,
                textQpcHafs: textQpcHafs,
                textDigitalKhatt: textDigitalKhatt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surah,
                required int ayah,
                required int juz,
                required int hizb,
                required int rub,
                Value<int?> sajdah = const Value.absent(),
                required String textUthmani,
                required String textQpcHafs,
                required String textDigitalKhatt,
              }) => AyahsCompanion.insert(
                id: id,
                surah: surah,
                ayah: ayah,
                juz: juz,
                hizb: hizb,
                rub: rub,
                sajdah: sajdah,
                textUthmani: textUthmani,
                textQpcHafs: textQpcHafs,
                textDigitalKhatt: textDigitalKhatt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AyahsTable, AyahRow>(table),
                  $$AyahsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({surah = false, wordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (wordsRefs) db.words],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (surah) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.surah,
                        referencedTable: $$AyahsTableReferences._surahTable(db),
                        referencedColumn: $$AyahsTableReferences
                            ._surahTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (wordsRefs)
                    await $_getPrefetchedDataByColumns<
                      AyahRow,
                      $AyahsTable,
                      WordRow,
                      $WordsTable
                    >(
                      currentTable: table,
                      referencedTable: $$AyahsTableReferences._wordsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$AyahsTableReferences(db, table, p0).wordsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'ayah_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AyahsTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $AyahsTable,
      AyahRow,
      $$AyahsTableFilterComposer,
      $$AyahsTableOrderingComposer,
      $$AyahsTableAnnotationComposer,
      $$AyahsTableCreateCompanionBuilder,
      $$AyahsTableUpdateCompanionBuilder,
      (AyahRow, $$AyahsTableReferences),
      AyahRow,
      PrefetchHooks Function({bool surah, bool wordsRefs})
    >;
typedef $$WordsTableCreateCompanionBuilder = WordsCompanion Function({
  Value<int> id,
  required int ayahId,
  required int surah,
  required int ayah,
  required int position,
  required bool isAyahEnd,
  required String wordText,
  required int morphFirst,
  required int morphLast,
});
typedef $$WordsTableUpdateCompanionBuilder = WordsCompanion Function({
  Value<int> id,
  Value<int> ayahId,
  Value<int> surah,
  Value<int> ayah,
  Value<int> position,
  Value<bool> isAyahEnd,
  Value<String> wordText,
  Value<int> morphFirst,
  Value<int> morphLast,
});

final class $$WordsTableReferences
    extends BaseReferences<_$ContentDatabase, $WordsTable, WordRow> {
  $$WordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AyahsTable _ayahIdTable(_$ContentDatabase db) =>
      db.ayahs.createAlias('words__ayah_id__ayahs__id');

  $$AyahsTableProcessedTableManager get ayahId {
    final $_column = $_itemColumn<int>('ayah_id')!;

    final manager = $$AyahsTableTableManager(
      $_db,
      $_db.ayahs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ayahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WordsTableFilterComposer
    extends Composer<_$ContentDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surah => $composableBuilder(
    column: $table.surah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayah => $composableBuilder(
    column: $table.ayah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAyahEnd => $composableBuilder(
    column: $table.isAyahEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wordText => $composableBuilder(
    column: $table.wordText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get morphFirst => $composableBuilder(
    column: $table.morphFirst,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get morphLast => $composableBuilder(
    column: $table.morphLast,
    builder: (column) => ColumnFilters(column),
  );

  $$AyahsTableFilterComposer get ayahId {
    final $$AyahsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ayahId,
      referencedTable: $db.ayahs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AyahsTableFilterComposer(
            $db: $db,
            $table: $db.ayahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordsTableOrderingComposer
    extends Composer<_$ContentDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surah => $composableBuilder(
    column: $table.surah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayah => $composableBuilder(
    column: $table.ayah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAyahEnd => $composableBuilder(
    column: $table.isAyahEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wordText => $composableBuilder(
    column: $table.wordText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get morphFirst => $composableBuilder(
    column: $table.morphFirst,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get morphLast => $composableBuilder(
    column: $table.morphLast,
    builder: (column) => ColumnOrderings(column),
  );

  $$AyahsTableOrderingComposer get ayahId {
    final $$AyahsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ayahId,
      referencedTable: $db.ayahs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AyahsTableOrderingComposer(
            $db: $db,
            $table: $db.ayahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surah =>
      $composableBuilder(column: $table.surah, builder: (column) => column);

  GeneratedColumn<int> get ayah =>
      $composableBuilder(column: $table.ayah, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<bool> get isAyahEnd =>
      $composableBuilder(column: $table.isAyahEnd, builder: (column) => column);

  GeneratedColumn<String> get wordText =>
      $composableBuilder(column: $table.wordText, builder: (column) => column);

  GeneratedColumn<int> get morphFirst => $composableBuilder(
    column: $table.morphFirst,
    builder: (column) => column,
  );

  GeneratedColumn<int> get morphLast =>
      $composableBuilder(column: $table.morphLast, builder: (column) => column);

  $$AyahsTableAnnotationComposer get ayahId {
    final $$AyahsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ayahId,
      referencedTable: $db.ayahs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AyahsTableAnnotationComposer(
            $db: $db,
            $table: $db.ayahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordsTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $WordsTable,
          WordRow,
          $$WordsTableFilterComposer,
          $$WordsTableOrderingComposer,
          $$WordsTableAnnotationComposer,
          $$WordsTableCreateCompanionBuilder,
          $$WordsTableUpdateCompanionBuilder,
          (WordRow, $$WordsTableReferences),
          WordRow,
          PrefetchHooks Function({bool ayahId})
        > {
  $$WordsTableTableManager(_$ContentDatabase db, $WordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ayahId = const Value.absent(),
                Value<int> surah = const Value.absent(),
                Value<int> ayah = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<bool> isAyahEnd = const Value.absent(),
                Value<String> wordText = const Value.absent(),
                Value<int> morphFirst = const Value.absent(),
                Value<int> morphLast = const Value.absent(),
              }) => WordsCompanion(
                id: id,
                ayahId: ayahId,
                surah: surah,
                ayah: ayah,
                position: position,
                isAyahEnd: isAyahEnd,
                wordText: wordText,
                morphFirst: morphFirst,
                morphLast: morphLast,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ayahId,
                required int surah,
                required int ayah,
                required int position,
                required bool isAyahEnd,
                required String wordText,
                required int morphFirst,
                required int morphLast,
              }) => WordsCompanion.insert(
                id: id,
                ayahId: ayahId,
                surah: surah,
                ayah: ayah,
                position: position,
                isAyahEnd: isAyahEnd,
                wordText: wordText,
                morphFirst: morphFirst,
                morphLast: morphLast,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WordsTable, WordRow>(table),
                  $$WordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ayahId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ayahId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ayahId,
                        referencedTable: $$WordsTableReferences._ayahIdTable(
                          db,
                        ),
                        referencedColumn: $$WordsTableReferences
                            ._ayahIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WordsTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $WordsTable,
      WordRow,
      $$WordsTableFilterComposer,
      $$WordsTableOrderingComposer,
      $$WordsTableAnnotationComposer,
      $$WordsTableCreateCompanionBuilder,
      $$WordsTableUpdateCompanionBuilder,
      (WordRow, $$WordsTableReferences),
      WordRow,
      PrefetchHooks Function({bool ayahId})
    >;
typedef $$MushafLayoutsTableCreateCompanionBuilder =
    MushafLayoutsCompanion Function({
      required String id,
      required String name,
      required int pageCount,
      required int linesPerPage,
      required String fontPack,
      required int version,
      Value<int> rowid,
    });
typedef $$MushafLayoutsTableUpdateCompanionBuilder =
    MushafLayoutsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> pageCount,
      Value<int> linesPerPage,
      Value<String> fontPack,
      Value<int> version,
      Value<int> rowid,
    });

final class $$MushafLayoutsTableReferences
    extends
        BaseReferences<
          _$ContentDatabase,
          $MushafLayoutsTable,
          MushafLayoutRow
        > {
  $$MushafLayoutsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$LayoutLinesTable, List<LayoutLineRow>>
  _layoutLinesRefsTable(_$ContentDatabase db) => MultiTypedResultKey.fromTable(
    db.layoutLines,
    aliasName: 'mushaf_layouts__id__layout_lines__layout_id',
  );

  $$LayoutLinesTableProcessedTableManager get layoutLinesRefs {
    final manager = $$LayoutLinesTableTableManager(
      $_db,
      $_db.layoutLines,
    ).filter((f) => f.layoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_layoutLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LayoutPagesTable, List<LayoutPageRow>>
  _layoutPagesRefsTable(_$ContentDatabase db) => MultiTypedResultKey.fromTable(
    db.layoutPages,
    aliasName: 'mushaf_layouts__id__layout_pages__layout_id',
  );

  $$LayoutPagesTableProcessedTableManager get layoutPagesRefs {
    final manager = $$LayoutPagesTableTableManager(
      $_db,
      $_db.layoutPages,
    ).filter((f) => f.layoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_layoutPagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LayoutGlyphsTable, List<LayoutGlyphRow>>
  _layoutGlyphsRefsTable(_$ContentDatabase db) => MultiTypedResultKey.fromTable(
    db.layoutGlyphs,
    aliasName: 'mushaf_layouts__id__layout_glyphs__layout_id',
  );

  $$LayoutGlyphsTableProcessedTableManager get layoutGlyphsRefs {
    final manager = $$LayoutGlyphsTableTableManager(
      $_db,
      $_db.layoutGlyphs,
    ).filter((f) => f.layoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_layoutGlyphsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MushafLayoutsTableFilterComposer
    extends Composer<_$ContentDatabase, $MushafLayoutsTable> {
  $$MushafLayoutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get linesPerPage => $composableBuilder(
    column: $table.linesPerPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fontPack => $composableBuilder(
    column: $table.fontPack,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> layoutLinesRefs(
    Expression<bool> Function($$LayoutLinesTableFilterComposer f) f,
  ) {
    final $$LayoutLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.layoutLines,
      getReferencedColumn: (t) => t.layoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutLinesTableFilterComposer(
            $db: $db,
            $table: $db.layoutLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> layoutPagesRefs(
    Expression<bool> Function($$LayoutPagesTableFilterComposer f) f,
  ) {
    final $$LayoutPagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.layoutPages,
      getReferencedColumn: (t) => t.layoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutPagesTableFilterComposer(
            $db: $db,
            $table: $db.layoutPages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> layoutGlyphsRefs(
    Expression<bool> Function($$LayoutGlyphsTableFilterComposer f) f,
  ) {
    final $$LayoutGlyphsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.layoutGlyphs,
      getReferencedColumn: (t) => t.layoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutGlyphsTableFilterComposer(
            $db: $db,
            $table: $db.layoutGlyphs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MushafLayoutsTableOrderingComposer
    extends Composer<_$ContentDatabase, $MushafLayoutsTable> {
  $$MushafLayoutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get linesPerPage => $composableBuilder(
    column: $table.linesPerPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fontPack => $composableBuilder(
    column: $table.fontPack,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MushafLayoutsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $MushafLayoutsTable> {
  $$MushafLayoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get pageCount =>
      $composableBuilder(column: $table.pageCount, builder: (column) => column);

  GeneratedColumn<int> get linesPerPage => $composableBuilder(
    column: $table.linesPerPage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fontPack =>
      $composableBuilder(column: $table.fontPack, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  Expression<T> layoutLinesRefs<T extends Object>(
    Expression<T> Function($$LayoutLinesTableAnnotationComposer a) f,
  ) {
    final $$LayoutLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.layoutLines,
      getReferencedColumn: (t) => t.layoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.layoutLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> layoutPagesRefs<T extends Object>(
    Expression<T> Function($$LayoutPagesTableAnnotationComposer a) f,
  ) {
    final $$LayoutPagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.layoutPages,
      getReferencedColumn: (t) => t.layoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutPagesTableAnnotationComposer(
            $db: $db,
            $table: $db.layoutPages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> layoutGlyphsRefs<T extends Object>(
    Expression<T> Function($$LayoutGlyphsTableAnnotationComposer a) f,
  ) {
    final $$LayoutGlyphsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.layoutGlyphs,
      getReferencedColumn: (t) => t.layoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LayoutGlyphsTableAnnotationComposer(
            $db: $db,
            $table: $db.layoutGlyphs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MushafLayoutsTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $MushafLayoutsTable,
          MushafLayoutRow,
          $$MushafLayoutsTableFilterComposer,
          $$MushafLayoutsTableOrderingComposer,
          $$MushafLayoutsTableAnnotationComposer,
          $$MushafLayoutsTableCreateCompanionBuilder,
          $$MushafLayoutsTableUpdateCompanionBuilder,
          (MushafLayoutRow, $$MushafLayoutsTableReferences),
          MushafLayoutRow,
          PrefetchHooks Function({
            bool layoutLinesRefs,
            bool layoutPagesRefs,
            bool layoutGlyphsRefs,
          })
        > {
  $$MushafLayoutsTableTableManager(
    _$ContentDatabase db,
    $MushafLayoutsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MushafLayoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MushafLayoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MushafLayoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> pageCount = const Value.absent(),
                Value<int> linesPerPage = const Value.absent(),
                Value<String> fontPack = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MushafLayoutsCompanion(
                id: id,
                name: name,
                pageCount: pageCount,
                linesPerPage: linesPerPage,
                fontPack: fontPack,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int pageCount,
                required int linesPerPage,
                required String fontPack,
                required int version,
                Value<int> rowid = const Value.absent(),
              }) => MushafLayoutsCompanion.insert(
                id: id,
                name: name,
                pageCount: pageCount,
                linesPerPage: linesPerPage,
                fontPack: fontPack,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MushafLayoutsTable, MushafLayoutRow>(table),
                  $$MushafLayoutsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                layoutLinesRefs = false,
                layoutPagesRefs = false,
                layoutGlyphsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (layoutLinesRefs) db.layoutLines,
                    if (layoutPagesRefs) db.layoutPages,
                    if (layoutGlyphsRefs) db.layoutGlyphs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (layoutLinesRefs)
                        await $_getPrefetchedDataByColumns<
                          MushafLayoutRow,
                          $MushafLayoutsTable,
                          LayoutLineRow,
                          $LayoutLinesTable
                        >(
                          currentTable: table,
                          referencedTable: $$MushafLayoutsTableReferences
                              ._layoutLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MushafLayoutsTableReferences(
                                db,
                                table,
                                p0,
                              ).layoutLinesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'layout_id',
                          typedResults: items,
                        ),
                      if (layoutPagesRefs)
                        await $_getPrefetchedDataByColumns<
                          MushafLayoutRow,
                          $MushafLayoutsTable,
                          LayoutPageRow,
                          $LayoutPagesTable
                        >(
                          currentTable: table,
                          referencedTable: $$MushafLayoutsTableReferences
                              ._layoutPagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MushafLayoutsTableReferences(
                                db,
                                table,
                                p0,
                              ).layoutPagesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'layout_id',
                          typedResults: items,
                        ),
                      if (layoutGlyphsRefs)
                        await $_getPrefetchedDataByColumns<
                          MushafLayoutRow,
                          $MushafLayoutsTable,
                          LayoutGlyphRow,
                          $LayoutGlyphsTable
                        >(
                          currentTable: table,
                          referencedTable: $$MushafLayoutsTableReferences
                              ._layoutGlyphsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MushafLayoutsTableReferences(
                                db,
                                table,
                                p0,
                              ).layoutGlyphsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'layout_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MushafLayoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $MushafLayoutsTable,
      MushafLayoutRow,
      $$MushafLayoutsTableFilterComposer,
      $$MushafLayoutsTableOrderingComposer,
      $$MushafLayoutsTableAnnotationComposer,
      $$MushafLayoutsTableCreateCompanionBuilder,
      $$MushafLayoutsTableUpdateCompanionBuilder,
      (MushafLayoutRow, $$MushafLayoutsTableReferences),
      MushafLayoutRow,
      PrefetchHooks Function({
        bool layoutLinesRefs,
        bool layoutPagesRefs,
        bool layoutGlyphsRefs,
      })
    >;
typedef $$LayoutLinesTableCreateCompanionBuilder =
    LayoutLinesCompanion Function({
      required String layoutId,
      required int page,
      required int line,
      required LayoutLineType type,
      Value<int?> surah,
      required bool isCentered,
      Value<int?> firstGlyphId,
      Value<int?> lastGlyphId,
      Value<int> rowid,
    });
typedef $$LayoutLinesTableUpdateCompanionBuilder =
    LayoutLinesCompanion Function({
      Value<String> layoutId,
      Value<int> page,
      Value<int> line,
      Value<LayoutLineType> type,
      Value<int?> surah,
      Value<bool> isCentered,
      Value<int?> firstGlyphId,
      Value<int?> lastGlyphId,
      Value<int> rowid,
    });

final class $$LayoutLinesTableReferences
    extends
        BaseReferences<_$ContentDatabase, $LayoutLinesTable, LayoutLineRow> {
  $$LayoutLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MushafLayoutsTable _layoutIdTable(_$ContentDatabase db) => db
      .mushafLayouts
      .createAlias('layout_lines__layout_id__mushaf_layouts__id');

  $$MushafLayoutsTableProcessedTableManager get layoutId {
    final $_column = $_itemColumn<String>('layout_id')!;

    final manager = $$MushafLayoutsTableTableManager(
      $_db,
      $_db.mushafLayouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_layoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LayoutLinesTableFilterComposer
    extends Composer<_$ContentDatabase, $LayoutLinesTable> {
  $$LayoutLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get line => $composableBuilder(
    column: $table.line,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LayoutLineType, LayoutLineType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get surah => $composableBuilder(
    column: $table.surah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCentered => $composableBuilder(
    column: $table.isCentered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstGlyphId => $composableBuilder(
    column: $table.firstGlyphId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastGlyphId => $composableBuilder(
    column: $table.lastGlyphId,
    builder: (column) => ColumnFilters(column),
  );

  $$MushafLayoutsTableFilterComposer get layoutId {
    final $$MushafLayoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.layoutId,
      referencedTable: $db.mushafLayouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MushafLayoutsTableFilterComposer(
            $db: $db,
            $table: $db.mushafLayouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutLinesTableOrderingComposer
    extends Composer<_$ContentDatabase, $LayoutLinesTable> {
  $$LayoutLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get line => $composableBuilder(
    column: $table.line,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surah => $composableBuilder(
    column: $table.surah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCentered => $composableBuilder(
    column: $table.isCentered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstGlyphId => $composableBuilder(
    column: $table.firstGlyphId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastGlyphId => $composableBuilder(
    column: $table.lastGlyphId,
    builder: (column) => ColumnOrderings(column),
  );

  $$MushafLayoutsTableOrderingComposer get layoutId {
    final $$MushafLayoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.layoutId,
      referencedTable: $db.mushafLayouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MushafLayoutsTableOrderingComposer(
            $db: $db,
            $table: $db.mushafLayouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutLinesTableAnnotationComposer
    extends Composer<_$ContentDatabase, $LayoutLinesTable> {
  $$LayoutLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<int> get line =>
      $composableBuilder(column: $table.line, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LayoutLineType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get surah =>
      $composableBuilder(column: $table.surah, builder: (column) => column);

  GeneratedColumn<bool> get isCentered => $composableBuilder(
    column: $table.isCentered,
    builder: (column) => column,
  );

  GeneratedColumn<int> get firstGlyphId => $composableBuilder(
    column: $table.firstGlyphId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastGlyphId => $composableBuilder(
    column: $table.lastGlyphId,
    builder: (column) => column,
  );

  $$MushafLayoutsTableAnnotationComposer get layoutId {
    final $$MushafLayoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.layoutId,
      referencedTable: $db.mushafLayouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MushafLayoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.mushafLayouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutLinesTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $LayoutLinesTable,
          LayoutLineRow,
          $$LayoutLinesTableFilterComposer,
          $$LayoutLinesTableOrderingComposer,
          $$LayoutLinesTableAnnotationComposer,
          $$LayoutLinesTableCreateCompanionBuilder,
          $$LayoutLinesTableUpdateCompanionBuilder,
          (LayoutLineRow, $$LayoutLinesTableReferences),
          LayoutLineRow,
          PrefetchHooks Function({bool layoutId})
        > {
  $$LayoutLinesTableTableManager(_$ContentDatabase db, $LayoutLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LayoutLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LayoutLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LayoutLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> layoutId = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<int> line = const Value.absent(),
                Value<LayoutLineType> type = const Value.absent(),
                Value<int?> surah = const Value.absent(),
                Value<bool> isCentered = const Value.absent(),
                Value<int?> firstGlyphId = const Value.absent(),
                Value<int?> lastGlyphId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LayoutLinesCompanion(
                layoutId: layoutId,
                page: page,
                line: line,
                type: type,
                surah: surah,
                isCentered: isCentered,
                firstGlyphId: firstGlyphId,
                lastGlyphId: lastGlyphId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String layoutId,
                required int page,
                required int line,
                required LayoutLineType type,
                Value<int?> surah = const Value.absent(),
                required bool isCentered,
                Value<int?> firstGlyphId = const Value.absent(),
                Value<int?> lastGlyphId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LayoutLinesCompanion.insert(
                layoutId: layoutId,
                page: page,
                line: line,
                type: type,
                surah: surah,
                isCentered: isCentered,
                firstGlyphId: firstGlyphId,
                lastGlyphId: lastGlyphId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LayoutLinesTable, LayoutLineRow>(table),
                  $$LayoutLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({layoutId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (layoutId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.layoutId,
                        referencedTable: $$LayoutLinesTableReferences
                            ._layoutIdTable(db),
                        referencedColumn: $$LayoutLinesTableReferences
                            ._layoutIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LayoutLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $LayoutLinesTable,
      LayoutLineRow,
      $$LayoutLinesTableFilterComposer,
      $$LayoutLinesTableOrderingComposer,
      $$LayoutLinesTableAnnotationComposer,
      $$LayoutLinesTableCreateCompanionBuilder,
      $$LayoutLinesTableUpdateCompanionBuilder,
      (LayoutLineRow, $$LayoutLinesTableReferences),
      LayoutLineRow,
      PrefetchHooks Function({bool layoutId})
    >;
typedef $$LayoutPagesTableCreateCompanionBuilder =
    LayoutPagesCompanion Function({
      required String layoutId,
      required int page,
      required int firstAyahId,
      required int lastAyahId,
      Value<int> rowid,
    });
typedef $$LayoutPagesTableUpdateCompanionBuilder =
    LayoutPagesCompanion Function({
      Value<String> layoutId,
      Value<int> page,
      Value<int> firstAyahId,
      Value<int> lastAyahId,
      Value<int> rowid,
    });

final class $$LayoutPagesTableReferences
    extends
        BaseReferences<_$ContentDatabase, $LayoutPagesTable, LayoutPageRow> {
  $$LayoutPagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MushafLayoutsTable _layoutIdTable(_$ContentDatabase db) => db
      .mushafLayouts
      .createAlias('layout_pages__layout_id__mushaf_layouts__id');

  $$MushafLayoutsTableProcessedTableManager get layoutId {
    final $_column = $_itemColumn<String>('layout_id')!;

    final manager = $$MushafLayoutsTableTableManager(
      $_db,
      $_db.mushafLayouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_layoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LayoutPagesTableFilterComposer
    extends Composer<_$ContentDatabase, $LayoutPagesTable> {
  $$LayoutPagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstAyahId => $composableBuilder(
    column: $table.firstAyahId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastAyahId => $composableBuilder(
    column: $table.lastAyahId,
    builder: (column) => ColumnFilters(column),
  );

  $$MushafLayoutsTableFilterComposer get layoutId {
    final $$MushafLayoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.layoutId,
      referencedTable: $db.mushafLayouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MushafLayoutsTableFilterComposer(
            $db: $db,
            $table: $db.mushafLayouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutPagesTableOrderingComposer
    extends Composer<_$ContentDatabase, $LayoutPagesTable> {
  $$LayoutPagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstAyahId => $composableBuilder(
    column: $table.firstAyahId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastAyahId => $composableBuilder(
    column: $table.lastAyahId,
    builder: (column) => ColumnOrderings(column),
  );

  $$MushafLayoutsTableOrderingComposer get layoutId {
    final $$MushafLayoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.layoutId,
      referencedTable: $db.mushafLayouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MushafLayoutsTableOrderingComposer(
            $db: $db,
            $table: $db.mushafLayouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutPagesTableAnnotationComposer
    extends Composer<_$ContentDatabase, $LayoutPagesTable> {
  $$LayoutPagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<int> get firstAyahId => $composableBuilder(
    column: $table.firstAyahId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastAyahId => $composableBuilder(
    column: $table.lastAyahId,
    builder: (column) => column,
  );

  $$MushafLayoutsTableAnnotationComposer get layoutId {
    final $$MushafLayoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.layoutId,
      referencedTable: $db.mushafLayouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MushafLayoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.mushafLayouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutPagesTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $LayoutPagesTable,
          LayoutPageRow,
          $$LayoutPagesTableFilterComposer,
          $$LayoutPagesTableOrderingComposer,
          $$LayoutPagesTableAnnotationComposer,
          $$LayoutPagesTableCreateCompanionBuilder,
          $$LayoutPagesTableUpdateCompanionBuilder,
          (LayoutPageRow, $$LayoutPagesTableReferences),
          LayoutPageRow,
          PrefetchHooks Function({bool layoutId})
        > {
  $$LayoutPagesTableTableManager(_$ContentDatabase db, $LayoutPagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LayoutPagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LayoutPagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LayoutPagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> layoutId = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<int> firstAyahId = const Value.absent(),
                Value<int> lastAyahId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LayoutPagesCompanion(
                layoutId: layoutId,
                page: page,
                firstAyahId: firstAyahId,
                lastAyahId: lastAyahId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String layoutId,
                required int page,
                required int firstAyahId,
                required int lastAyahId,
                Value<int> rowid = const Value.absent(),
              }) => LayoutPagesCompanion.insert(
                layoutId: layoutId,
                page: page,
                firstAyahId: firstAyahId,
                lastAyahId: lastAyahId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LayoutPagesTable, LayoutPageRow>(table),
                  $$LayoutPagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({layoutId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (layoutId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.layoutId,
                        referencedTable: $$LayoutPagesTableReferences
                            ._layoutIdTable(db),
                        referencedColumn: $$LayoutPagesTableReferences
                            ._layoutIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LayoutPagesTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $LayoutPagesTable,
      LayoutPageRow,
      $$LayoutPagesTableFilterComposer,
      $$LayoutPagesTableOrderingComposer,
      $$LayoutPagesTableAnnotationComposer,
      $$LayoutPagesTableCreateCompanionBuilder,
      $$LayoutPagesTableUpdateCompanionBuilder,
      (LayoutPageRow, $$LayoutPagesTableReferences),
      LayoutPageRow,
      PrefetchHooks Function({bool layoutId})
    >;
typedef $$LayoutGlyphsTableCreateCompanionBuilder =
    LayoutGlyphsCompanion Function({
      required String layoutId,
      required int id,
      required int firstWordId,
      required int lastWordId,
      required String glyph,
      Value<String?> digitalKhattText,
      Value<int> rowid,
    });
typedef $$LayoutGlyphsTableUpdateCompanionBuilder =
    LayoutGlyphsCompanion Function({
      Value<String> layoutId,
      Value<int> id,
      Value<int> firstWordId,
      Value<int> lastWordId,
      Value<String> glyph,
      Value<String?> digitalKhattText,
      Value<int> rowid,
    });

final class $$LayoutGlyphsTableReferences
    extends
        BaseReferences<_$ContentDatabase, $LayoutGlyphsTable, LayoutGlyphRow> {
  $$LayoutGlyphsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MushafLayoutsTable _layoutIdTable(_$ContentDatabase db) => db
      .mushafLayouts
      .createAlias('layout_glyphs__layout_id__mushaf_layouts__id');

  $$MushafLayoutsTableProcessedTableManager get layoutId {
    final $_column = $_itemColumn<String>('layout_id')!;

    final manager = $$MushafLayoutsTableTableManager(
      $_db,
      $_db.mushafLayouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_layoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WordsTable _firstWordIdTable(_$ContentDatabase db) =>
      db.words.createAlias('layout_glyphs__first_word_id__words__id');

  $$WordsTableProcessedTableManager get firstWordId {
    final $_column = $_itemColumn<int>('first_word_id')!;

    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_firstWordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WordsTable _lastWordIdTable(_$ContentDatabase db) =>
      db.words.createAlias('layout_glyphs__last_word_id__words__id');

  $$WordsTableProcessedTableManager get lastWordId {
    final $_column = $_itemColumn<int>('last_word_id')!;

    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lastWordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LayoutGlyphsTableFilterComposer
    extends Composer<_$ContentDatabase, $LayoutGlyphsTable> {
  $$LayoutGlyphsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get glyph => $composableBuilder(
    column: $table.glyph,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get digitalKhattText => $composableBuilder(
    column: $table.digitalKhattText,
    builder: (column) => ColumnFilters(column),
  );

  $$MushafLayoutsTableFilterComposer get layoutId {
    final $$MushafLayoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.layoutId,
      referencedTable: $db.mushafLayouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MushafLayoutsTableFilterComposer(
            $db: $db,
            $table: $db.mushafLayouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WordsTableFilterComposer get firstWordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.firstWordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WordsTableFilterComposer get lastWordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lastWordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutGlyphsTableOrderingComposer
    extends Composer<_$ContentDatabase, $LayoutGlyphsTable> {
  $$LayoutGlyphsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get glyph => $composableBuilder(
    column: $table.glyph,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get digitalKhattText => $composableBuilder(
    column: $table.digitalKhattText,
    builder: (column) => ColumnOrderings(column),
  );

  $$MushafLayoutsTableOrderingComposer get layoutId {
    final $$MushafLayoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.layoutId,
      referencedTable: $db.mushafLayouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MushafLayoutsTableOrderingComposer(
            $db: $db,
            $table: $db.mushafLayouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WordsTableOrderingComposer get firstWordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.firstWordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableOrderingComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WordsTableOrderingComposer get lastWordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lastWordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableOrderingComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutGlyphsTableAnnotationComposer
    extends Composer<_$ContentDatabase, $LayoutGlyphsTable> {
  $$LayoutGlyphsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get glyph =>
      $composableBuilder(column: $table.glyph, builder: (column) => column);

  GeneratedColumn<String> get digitalKhattText => $composableBuilder(
    column: $table.digitalKhattText,
    builder: (column) => column,
  );

  $$MushafLayoutsTableAnnotationComposer get layoutId {
    final $$MushafLayoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.layoutId,
      referencedTable: $db.mushafLayouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MushafLayoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.mushafLayouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WordsTableAnnotationComposer get firstWordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.firstWordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WordsTableAnnotationComposer get lastWordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lastWordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LayoutGlyphsTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $LayoutGlyphsTable,
          LayoutGlyphRow,
          $$LayoutGlyphsTableFilterComposer,
          $$LayoutGlyphsTableOrderingComposer,
          $$LayoutGlyphsTableAnnotationComposer,
          $$LayoutGlyphsTableCreateCompanionBuilder,
          $$LayoutGlyphsTableUpdateCompanionBuilder,
          (LayoutGlyphRow, $$LayoutGlyphsTableReferences),
          LayoutGlyphRow,
          PrefetchHooks Function({
            bool layoutId,
            bool firstWordId,
            bool lastWordId,
          })
        > {
  $$LayoutGlyphsTableTableManager(
    _$ContentDatabase db,
    $LayoutGlyphsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LayoutGlyphsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LayoutGlyphsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LayoutGlyphsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> layoutId = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<int> firstWordId = const Value.absent(),
                Value<int> lastWordId = const Value.absent(),
                Value<String> glyph = const Value.absent(),
                Value<String?> digitalKhattText = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LayoutGlyphsCompanion(
                layoutId: layoutId,
                id: id,
                firstWordId: firstWordId,
                lastWordId: lastWordId,
                glyph: glyph,
                digitalKhattText: digitalKhattText,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String layoutId,
                required int id,
                required int firstWordId,
                required int lastWordId,
                required String glyph,
                Value<String?> digitalKhattText = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LayoutGlyphsCompanion.insert(
                layoutId: layoutId,
                id: id,
                firstWordId: firstWordId,
                lastWordId: lastWordId,
                glyph: glyph,
                digitalKhattText: digitalKhattText,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LayoutGlyphsTable, LayoutGlyphRow>(table),
                  $$LayoutGlyphsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({layoutId = false, firstWordId = false, lastWordId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (layoutId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.layoutId,
                            referencedTable: $$LayoutGlyphsTableReferences
                                ._layoutIdTable(db),
                            referencedColumn: $$LayoutGlyphsTableReferences
                                ._layoutIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (firstWordId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.firstWordId,
                            referencedTable: $$LayoutGlyphsTableReferences
                                ._firstWordIdTable(db),
                            referencedColumn: $$LayoutGlyphsTableReferences
                                ._firstWordIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (lastWordId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.lastWordId,
                            referencedTable: $$LayoutGlyphsTableReferences
                                ._lastWordIdTable(db),
                            referencedColumn: $$LayoutGlyphsTableReferences
                                ._lastWordIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$LayoutGlyphsTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $LayoutGlyphsTable,
      LayoutGlyphRow,
      $$LayoutGlyphsTableFilterComposer,
      $$LayoutGlyphsTableOrderingComposer,
      $$LayoutGlyphsTableAnnotationComposer,
      $$LayoutGlyphsTableCreateCompanionBuilder,
      $$LayoutGlyphsTableUpdateCompanionBuilder,
      (LayoutGlyphRow, $$LayoutGlyphsTableReferences),
      LayoutGlyphRow,
      PrefetchHooks Function({bool layoutId, bool firstWordId, bool lastWordId})
    >;

class $ContentDatabaseManager {
  final _$ContentDatabase _db;
  $ContentDatabaseManager(this._db);
  $$ContentMetaTableTableManager get contentMeta =>
      $$ContentMetaTableTableManager(_db, _db.contentMeta);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db, _db.surahs);
  $$AyahsTableTableManager get ayahs =>
      $$AyahsTableTableManager(_db, _db.ayahs);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
  $$MushafLayoutsTableTableManager get mushafLayouts =>
      $$MushafLayoutsTableTableManager(_db, _db.mushafLayouts);
  $$LayoutLinesTableTableManager get layoutLines =>
      $$LayoutLinesTableTableManager(_db, _db.layoutLines);
  $$LayoutPagesTableTableManager get layoutPages =>
      $$LayoutPagesTableTableManager(_db, _db.layoutPages);
  $$LayoutGlyphsTableTableManager get layoutGlyphs =>
      $$LayoutGlyphsTableTableManager(_db, _db.layoutGlyphs);
}
