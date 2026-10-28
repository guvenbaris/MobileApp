import 'package:flutter/material.dart';

import 'app_palette.dart';
import 'app_typography.dart';

export 'app_palette.dart';
export 'app_typography.dart';

/// Kullanıcının tema seçimi. [system]: cihaz açık moddaysa açık, koyu
/// moddaysa koyu tema.
enum ThemePreference { system, light, sepia, dark }

/// Ölçüler. Boşluklar 4'ün katlarıdır; bileşenler bu değerleri kullanır.
abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;

  /// En küçük dokunma alanı. NF-E03 44×44 pt ister; Android'in önerisi
  /// 48×48 olduğu için ikisini de karşılayan 48 kullanılır.
  static const minTapTarget = 48.0;

  static const radius = 12.0;
}

/// Paletten Material temasını üretir. Bileşen görünümleri (düğme, liste,
/// çubuk…) burada tek yerden ayarlanır; ekranlarda stil tekrar yazılmaz.
ThemeData buildAppTheme(AppPalette p) {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: p.primary,
        brightness: p.brightness,
      ).copyWith(
        primary: p.primary,
        onPrimary: p.onPrimary,
        primaryContainer: p.primaryContainer,
        onPrimaryContainer: p.onPrimaryContainer,
        secondary: p.primary,
        onSecondary: p.onPrimary,
        secondaryContainer: p.primaryContainer,
        onSecondaryContainer: p.onPrimaryContainer,
        surface: p.surface,
        onSurface: p.onSurface,
        onSurfaceVariant: p.onSurfaceMuted,
        outline: p.outline,
        outlineVariant: p.outline.withValues(alpha: 0.4),
        error: p.error,
        onError: p.onError,
      );
  final textTheme = AppTypography.textTheme(p.brightness, p.onSurface);
  const minSize = Size(AppSpacing.minTapTarget, AppSpacing.minTapTarget);
  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppSpacing.radius),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: p.background,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    visualDensity: VisualDensity.standard,
    extensions: [p],
    appBarTheme: AppBarTheme(
      backgroundColor: p.background,
      foregroundColor: p.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: minSize, shape: shape),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: minSize,
        shape: shape,
        side: BorderSide(color: p.outline),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: minSize, shape: shape),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(minimumSize: minSize),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: p.primaryContainer,
      foregroundColor: p.onPrimaryContainer,
    ),
    listTileTheme: ListTileThemeData(
      minTileHeight: 56,
      iconColor: p.onSurfaceMuted,
      textColor: p.onSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    ),
    dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? p.primary
            : p.onSurfaceMuted,
      ),
    ),
  );
}
