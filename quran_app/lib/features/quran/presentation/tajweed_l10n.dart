import 'package:flutter/widgets.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/tajweed.dart';

extension TajweedRuleL10n on TajweedRule {
  String localizedName(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      TajweedRule.hamzatWasl => l.tajweedHamzatWasl,
      TajweedRule.lamShamsiyyah => l.tajweedLamShamsiyyah,
      TajweedRule.silent => l.tajweedSilent,
      TajweedRule.madd2 => l.tajweedMadd2,
      TajweedRule.madd246 => l.tajweedMadd246,
      TajweedRule.maddMunfasil => l.tajweedMaddMunfasil,
      TajweedRule.maddMuttasil => l.tajweedMaddMuttasil,
      TajweedRule.madd6 => l.tajweedMadd6,
      TajweedRule.ghunnah => l.tajweedGhunnah,
      TajweedRule.ikhfa => l.tajweedIkhfa,
      TajweedRule.ikhfaShafawi => l.tajweedIkhfaShafawi,
      TajweedRule.idghaamGhunnah => l.tajweedIdghaamGhunnah,
      TajweedRule.idghaamShafawi => l.tajweedIdghaamShafawi,
      TajweedRule.iqlab => l.tajweedIqlab,
      TajweedRule.idghaamNoGhunnah => l.tajweedIdghaamNoGhunnah,
      TajweedRule.idghaamMutajanisayn => l.tajweedIdghaamMutajanisayn,
      TajweedRule.idghaamMutaqaribayn => l.tajweedIdghaamMutaqaribayn,
      TajweedRule.qalqalah => l.tajweedQalqalah,
    };
  }

  /// Kısa açıklama (TR/AR/EN). İçerik kurulu gözden geçirmesi: AK-06.
  String localizedInfo(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      TajweedRule.hamzatWasl => l.tajweedHamzatWaslInfo,
      TajweedRule.lamShamsiyyah => l.tajweedLamShamsiyyahInfo,
      TajweedRule.silent => l.tajweedSilentInfo,
      TajweedRule.madd2 => l.tajweedMadd2Info,
      TajweedRule.madd246 => l.tajweedMadd246Info,
      TajweedRule.maddMunfasil => l.tajweedMaddMunfasilInfo,
      TajweedRule.maddMuttasil => l.tajweedMaddMuttasilInfo,
      TajweedRule.madd6 => l.tajweedMadd6Info,
      TajweedRule.ghunnah => l.tajweedGhunnahInfo,
      TajweedRule.ikhfa => l.tajweedIkhfaInfo,
      TajweedRule.ikhfaShafawi => l.tajweedIkhfaShafawiInfo,
      TajweedRule.idghaamGhunnah => l.tajweedIdghaamGhunnahInfo,
      TajweedRule.idghaamShafawi => l.tajweedIdghaamShafawiInfo,
      TajweedRule.iqlab => l.tajweedIqlabInfo,
      TajweedRule.idghaamNoGhunnah => l.tajweedIdghaamNoGhunnahInfo,
      TajweedRule.idghaamMutajanisayn => l.tajweedIdghaamMutajanisaynInfo,
      TajweedRule.idghaamMutaqaribayn => l.tajweedIdghaamMutaqaribaynInfo,
      TajweedRule.qalqalah => l.tajweedQalqalahInfo,
    };
  }
}

extension TajweedGroupL10n on TajweedGroup {
  String localizedName(BuildContext context) {
    final l = context.l10n;
    return switch (this) {
      TajweedGroup.silent => l.tajweedGroupSilent,
      TajweedGroup.maddNatural => l.tajweedGroupMaddNatural,
      TajweedGroup.maddPermissible => l.tajweedGroupMaddPermissible,
      TajweedGroup.maddObligatory => l.tajweedGroupMaddObligatory,
      TajweedGroup.ghunnah => l.tajweedGroupGhunnah,
      TajweedGroup.idghaam => l.tajweedGroupIdghaam,
      TajweedGroup.qalqalah => l.tajweedGroupQalqalah,
    };
  }

  Color color(TajweedColors c) => switch (this) {
    TajweedGroup.silent => c.silent,
    TajweedGroup.maddNatural => c.maddNatural,
    TajweedGroup.maddPermissible => c.maddPermissible,
    TajweedGroup.maddObligatory => c.maddObligatory,
    TajweedGroup.ghunnah => c.ghunnah,
    TajweedGroup.idghaam => c.idghaam,
    TajweedGroup.qalqalah => c.qalqalah,
  };
}
