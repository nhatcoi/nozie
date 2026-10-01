import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nozie_mobile/app/app_router.dart';
import 'package:nozie_mobile/core/enums/movie_type.dart';
import 'package:nozie_mobile/core/extension/context_extensions.dart';
import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/core/theme/app_colors.dart';
import 'package:nozie_mobile/core/theme/app_spacing.dart';
import 'package:nozie_mobile/core/utils/genres.dart';
import 'package:nozie_mobile/core/utils/image_constant.dart';
import 'package:nozie_mobile/core/widgets/movie_card.dart';
import 'package:nozie_mobile/features/home/home_providers.dart';

/// Shortcut tiles into the genre pages (the user's favourites first, otherwise all genres).
class HomeGenreSection extends ConsumerWidget {
  const HomeGenreSection({super.key});

  static const double _tileWidth = 160;
  static const double _tileHeight = 80;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(preferredGenresProvider).valueOrNull;
    if (names == null) return const SizedBox.shrink();
    final genres = GenresVi.fromNames(names);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.i18n.home.sections.exploreByGenre,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 22),
                ),
              ),
              IconButton(
                tooltip: context.i18n.home.sections.exploreByGenre,
                icon: const Icon(Icons.arrow_forward, color: AppColors.primary500),
                onPressed: () => context.push('${AppRouter.explore}/genre'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: _tileHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) {
                final genre = genres[index];
                final name = genre['name'] ?? '';
                final slug = genre['slug'] ?? name;
                return MovieCard(
                  movie: MovieItem(id: slug, title: name, imageUrl: genre['imageUrl'] ?? ImageConstant.imgCard),
                  width: _tileWidth,
                  height: _tileHeight,
                  movieCardType: MovieCardType.titleInImg,
                  enableNavigation: false,
                  onMore: () => context.push('${AppRouter.explore}/$slug'),
                  titleFontSize: 16,
                  overlayOpacity: 0.1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
