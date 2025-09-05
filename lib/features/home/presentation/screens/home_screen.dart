import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:movie_fe/core/app_export.dart';
import 'package:movie_fe/core/models/movie_item.dart';
import 'package:movie_fe/core/widgets/cards/movie_card.dart';
import 'package:movie_fe/core/widgets/lists/movie_carousel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MovieCarousel(
            title: "Recommended For You",
            items: new List<MovieItem>.generate(
              10,
              (index) => MovieItem(
                title: "Movie Aalxcvbhljxcvhxljchvkjxchvxkjhcv $index",
                imageUrl: ImageConstant.imgCard,
                rating: 4.5,
                price: 5.5,
                id: '123',
              ),
            ),
            onMore: () {

            },
          ),
        ],
      ),
    );
  }
}
