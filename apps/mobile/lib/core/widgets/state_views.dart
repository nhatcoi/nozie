import 'package:flutter/material.dart';
import 'package:nozie_mobile/core/theme/app_colors.dart';
import 'package:nozie_mobile/core/theme/app_spacing.dart';
import 'package:nozie_mobile/i18n/translations.g.dart';

/// Centered icon + title (+ message) (+ action). Base for the empty and error states.
class StateView extends StatelessWidget {
  const StateView({super.key, required this.icon, required this.title, this.message, this.actionLabel, this.onAction});

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.getTextSecondary(context)),
            const SizedBox(height: AppSpacing.lg),
            Text(title, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.getTextSecondary(context)),
              ),
            ],
            if (onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel ?? t.common.retry)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shown when a request fails. [message] should come from `errorMessage(error)`.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) =>
      StateView(icon: Icons.cloud_off_rounded, title: message, onAction: onRetry);
}

/// Shown when a request succeeds but there is nothing to list.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, this.message, this.icon = Icons.inbox_outlined});

  final String title;
  final String? message;
  final IconData icon;

  @override
  Widget build(BuildContext context) => StateView(icon: icon, title: title, message: message);
}
