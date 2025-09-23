import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_fe/core/enums/movie_type.dart';
import 'package:movie_fe/core/models/movie_item.dart';
import 'package:movie_fe/core/utils/image_constant.dart';
import 'package:movie_fe/core/widgets/cards/movie_card.dart';
import 'package:movie_fe/routes/app_router.dart';

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
            final crossAxisCount = 2;
            final double spacing = 12;
            final aspectRatio = 160 / 80;
            final screenWidth = constraints.maxWidth;

            final cardWidth =
                (screenWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;

            final cardHeight = cardWidth / aspectRatio;

            return GridView.builder(
              itemCount: 20,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: aspectRatio,
              ),
              itemBuilder: (context, i) => MovieCard(
                width: cardWidth,
                height: cardHeight,
                movie: MovieItem(
                  id: '1',
                  title: '123',
                  imageUrl: ImageConstant.imgCard,
                ),
                movieCardType: MovieCardType.titleInImg,
                onMore: (){
                  context.push('${AppRouter.movieCarouselGenre}1');
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
