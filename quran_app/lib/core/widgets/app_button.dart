import 'package:flutter/material.dart';

/// Düğme türleri. Görünüm `buildAppTheme` içindeki düğme temalarından gelir.
enum AppButtonKind {
  /// Ekranın ana eylemi (dolu).
  primary,

  /// İkincil eylem (çerçeveli).
  secondary,

  /// Hafif eylem (yalnızca metin).
  text,
}

/// Uygulamanın düğmesi. En küçük boyut 48×48 (NF-E03). Ekranlar doğrudan
/// `FilledButton` vb. yerine bunu kullanır; görünüm değişikliği tek yerden
/// yapılır.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.kind = AppButtonKind.primary,
    this.icon,
    super.key,
  });

  const AppButton.secondary({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  }) : kind = AppButtonKind.secondary;

  const AppButton.text({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  }) : kind = AppButtonKind.text;

  final String label;

  /// `null` ise düğme pasiftir.
  final VoidCallback? onPressed;
  final AppButtonKind kind;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final child = Text(label);
    final iconWidget = icon == null ? null : Icon(icon);
    return switch ((kind, iconWidget)) {
      (AppButtonKind.primary, null) => FilledButton(
        onPressed: onPressed,
        child: child,
      ),
      (AppButtonKind.primary, final i?) => FilledButton.icon(
        onPressed: onPressed,
        icon: i,
        label: child,
      ),
      (AppButtonKind.secondary, null) => OutlinedButton(
        onPressed: onPressed,
        child: child,
      ),
      (AppButtonKind.secondary, final i?) => OutlinedButton.icon(
        onPressed: onPressed,
        icon: i,
        label: child,
      ),
      (AppButtonKind.text, null) => TextButton(
        onPressed: onPressed,
        child: child,
      ),
      (AppButtonKind.text, final i?) => TextButton.icon(
        onPressed: onPressed,
        icon: i,
        label: child,
      ),
    };
  }
}
