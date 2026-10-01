import 'package:flutter/material.dart';
import 'package:nozie_mobile/core/enums/movie_type.dart';
import 'package:nozie_mobile/core/models/movie_item.dart';
import 'package:nozie_mobile/core/widgets/movie_card.dart';

class GridMovie extends StatelessWidget {
  const GridMovie({super.key, required this.movies});

  final List<MovieItem> movies;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          const crossAxisCount = 2;
          const double spacing = 12;
          const aspectRatio = 160 / 80;
          final screenWidth = constraints.maxWidth;

          final cardWidth =
              (screenWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;

          final cardHeight = cardWidth / aspectRatio;

          return GridView.builder(
            itemCount: movies.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (context, i) =>
                MovieCard(
                  width: cardWidth,
                  height: cardHeight,
                  movie: MovieItem(
                    id: movies[i].id,
                    title: movies[i].title,
                    imageUrl: movies[i].imageUrl,
                  ),
                  movieCardType: MovieCardType.titleInImg,
                  onMore: () {
                    // context.push('${AppRouter.movieCarouselGenre}1');
                  },
                ),
          );
        }
    );
  }
}
