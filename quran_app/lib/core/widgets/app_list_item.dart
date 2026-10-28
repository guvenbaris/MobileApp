import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Liste satırı. Yükseklik en az 56; tüm satır dokunulabilir (NF-E03).
/// Sağdan sola dillerde baş ve son kendiliğinden yer değiştirir.
class AppListItem extends StatelessWidget {
  const AppListItem({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return ListTile(
      onTap: onTap,
      leading: leading,
      title: Text(title),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, style: TextStyle(color: palette.onSurfaceMuted)),
      trailing: trailing,
    );
  }
}

/// Liste bölüm başlığı (ör. ayarlardaki "Dil").
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(color: context.palette.primary),
      ),
    );
  }
}
