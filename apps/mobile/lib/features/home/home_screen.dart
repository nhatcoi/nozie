import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nozie_mobile/app/app_router.dart';
import 'package:nozie_mobile/core/constants/app_padding.dart';
import 'package:nozie_mobile/core/extension/context_extensions.dart';
import 'package:nozie_mobile/core/repositories/movie_repository.dart';
import 'package:nozie_mobile/core/theme/app_spacing.dart';
import 'package:nozie_mobile/core/widgets/async_value_view.dart';
import 'package:nozie_mobile/features/home/home_genre_section.dart';
import 'package:nozie_mobile/features/home/home_hero_carousel.dart';
import 'package:nozie_mobile/features/home/home_providers.dart';
import 'package:nozie_mobile/features/home/home_section.dart';

/// Landing tab. The page is one scrollable list so pull-to-refresh reloads every section.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref
      ..invalidate(moviesProvider)
      ..invalidate(recommendedMoviesProvider)
      ..invalidate(preferredGenresProvider)
      ..invalidate(purchasedMoviesProvider)
      ..invalidate(wishlistMoviesProvider)
      ..invalidate(recentMoviesProvider);
    // Wait for the headline list so the spinner lasts as long as the page is really empty.
    await ref.read(moviesProvider.future).then((_) {}, onError: (_) {});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.i18n.home.sections;
    final headline = ref.watch(moviesProvider);

    return RefreshIndicator(
      onRefresh: () => _refresh(ref),
      child: AsyncValueView(
        value: headline,
        onRetry: () => ref.invalidate(moviesProvider),
        loading: const HomeSkeleton(),
        data: (movies) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: ResponsivePadding.content(context).copyWith(bottom: AppSpacing.xl),
          children: [
            HomeHeroCarousel(items: movies),
            const SizedBox(height: AppSpacing.lg),
            HomeMovieSection(
              title: t.recommendedForYou,
              provider: recommendedMoviesProvider,
              onMore: () => context.push('${AppRouter.movieType}/recommended'),
            ),
            const HomeGenreSection(),
            HomeMovieSection(
              title: t.yourPurchases,
              provider: purchasedMoviesProvider,
              onMore: () => context.push('${AppRouter.movieType}/purchase'),
            ),
            HomeMovieSection(
              title: t.yourWishlist,
              provider: wishlistMoviesProvider,
              onMore: () => context.push('${AppRouter.movieType}/wishlist'),
            ),
            HomeMovieSection(
              title: t.recentlyWatched,
              provider: recentMoviesProvider,
              onMore: () => context.push('${AppRouter.movieType}/recent'),
            ),
          ],
        ),
      ),
    );
  }
}
