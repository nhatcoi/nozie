import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nozie_mobile/core/enums/movie_type.dart';
import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/core/utils/image_constant.dart';
import 'package:nozie_mobile/core/utils/genres.dart';
import 'package:nozie_mobile/core/widgets/movie_card.dart';
import 'package:nozie_mobile/app/app_router.dart';

class ExploreGenre extends ConsumerWidget {
  const ExploreGenre({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24,16,24,16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const crossAxisCount = 2;
            const double spacing = 12;
            const aspectRatio = 160 / 80;
            final screenWidth = constraints.maxWidth;

            final cardWidth =
                (screenWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;

            final cardHeight = cardWidth / aspectRatio;

            const genres = GenresVi.all;
            return GridView.builder(
              itemCount: genres.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: aspectRatio,
              ),
              itemBuilder: (context, i) {
                final g = genres[i];
                final name = g['name'] ?? '';
                final slug = g['slug'] ?? name;
                final img = g['imageUrl'] ?? ImageConstant.imgCard;
                return MovieCard(
                  width: cardWidth,
                  height: cardHeight,
                  movie: MovieItem(
                    id: slug,
                    title: name,
                    imageUrl: img,
                  ),
                  movieCardType: MovieCardType.titleInImg,
                  onMore: (){
                    context.push('${AppRouter.movieCarouselGenre}$slug');
                  },
                  enableNavigation: false,
                  titleFontSize: 16,
                  overlayOpacity: 0.22,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
