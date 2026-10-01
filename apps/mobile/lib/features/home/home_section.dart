import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/core/network/error_messages.dart';
import 'package:nozie_mobile/core/theme/app_colors.dart';
import 'package:nozie_mobile/core/theme/app_spacing.dart';
import 'package:nozie_mobile/core/widgets/movie_carousel.dart';
import 'package:nozie_mobile/core/widgets/skeleton.dart';
import 'package:nozie_mobile/i18n/translations.g.dart';

/// A titled movie carousel backed by a provider. Empty lists collapse; a failed section shows a small
/// inline retry instead of taking over the page.
class HomeMovieSection extends ConsumerWidget {
  const HomeMovieSection({super.key, required this.title, required this.provider, required this.onMore});

  final String title;
  final AutoDisposeFutureProvider<List<MovieItem>> provider;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(provider).when(
          loading: () => const _SectionSkeleton(),
          error: (error, _) => _InlineError(message: errorMessage(error), onRetry: () => ref.invalidate(provider)),
          data: (items) => items.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  child: MovieCarousel(title: title, items: items, onMore: onMore),
                ),
        );
  }
}

class _SectionSkeleton extends StatelessWidget {
  const _SectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(width: 160, height: 22),
          SizedBox(height: AppSpacing.md),
          MovieRowSkeleton(),
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.getTextSecondary(context)),
            ),
          ),
          TextButton(onPressed: onRetry, child: Text(t.common.retry)),
        ],
      ),
    );
  }
}
