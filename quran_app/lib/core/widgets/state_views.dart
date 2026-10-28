import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import 'app_button.dart';

/// Yükleniyor durumu.
class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(semanticsLabel: context.l10n.loading),
  );
}

/// Boş durum: gösterilecek bir şey yokken (ör. yer imi yok). İsteğe bağlı
/// bir eylem düğmesi alır.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => _StateLayout(
    icon: icon,
    iconColor: context.palette.onSurfaceMuted,
    title: title,
    message: message,
    action: actionLabel == null
        ? null
        : AppButton.secondary(label: actionLabel!, onPressed: onAction),
  );
}

/// Hata durumu: veri okunamadığında. Kullanıcıya genel bir açıklama ve
/// "Tekrar dene" gösterilir; teknik ayrıntı yalnızca debug derlemesinde
/// görünür (ham hata metni kullanıcıya gösterilmez).
class ErrorState extends StatelessWidget {
  const ErrorState({this.message, this.error, this.onRetry, super.key});

  /// Kullanıcıya gösterilecek açıklama; yoksa genel metin.
  final String? message;

  /// Teknik ayrıntı (yalnızca debug derlemesinde gösterilir).
  final Object? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Hata belirince ekran okuyucu duyurur (M13-03).
    return Semantics(
      liveRegion: true,
      child: _StateLayout(
        icon: Icons.error_outline,
        iconColor: context.palette.error,
        title: l10n.errorTitle,
        message: message ?? l10n.errorLoadContent,
        detail: kDebugMode && error != null ? '$error' : null,
        action: onRetry == null
            ? null
            : AppButton(
                key: const Key('errorState.retry'),
                label: l10n.errorRetry,
                icon: Icons.refresh,
                onPressed: onRetry,
              ),
      ),
    );
  }
}

class _StateLayout extends StatelessWidget {
  const _StateLayout({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.message,
    this.detail,
    this.action,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? message;
  final String? detail;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final muted = context.palette.onSurfaceMuted;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Simge süstür; anlamı başlık taşır.
            ExcludeSemantics(child: Icon(icon, size: 48, color: iconColor)),
            const SizedBox(height: AppSpacing.md),
            Semantics(
              header: true,
              child: Text(
                title,
                style: text.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                message!,
                style: text.bodyMedium?.copyWith(color: muted),
                textAlign: TextAlign.center,
              ),
            ],
            if (detail != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                detail!,
                style: text.bodySmall?.copyWith(color: muted),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
