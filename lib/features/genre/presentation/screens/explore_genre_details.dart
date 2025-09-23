import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:movie_fe/core/app_export.dart';
import 'package:movie_fe/core/models/movie_item.dart';
import 'package:movie_fe/core/widgets/lists/grid_movie.dart';
import 'package:movie_fe/core/widgets/lists/list_title_movie.dart';

enum ViewMode { grid, list }

final viewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.grid);

class ExploreGenreDetails extends ConsumerWidget {
  const ExploreGenreDetails({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.i18n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mode = ref.watch(viewModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Genre: $query')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t.cards.showIn, style: theme.textTheme.headlineMedium),

                  Row(
                    children: [
                      _ModeButton(
                        asset: ImageConstant.categoryIcon,
                        isActive: mode == ViewMode.grid,
                        onTap: () {
                          ref.read(viewModeProvider.notifier).state =
                              ViewMode.grid;
                        },
                      ),
                      const Gap(16),
                      _ModeButton(
                        asset: ImageConstant.listCategoryIcon,
                        isActive: mode == ViewMode.list,
                        onTap: () {
                          ref.read(viewModeProvider.notifier).state =
                              ViewMode.list;
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(24),
              ref.read(viewModeProvider.notifier).state == ViewMode.grid
                  ? Expanded(
                      child: GridMovie(
                        movies: List.generate(
                          20,
                          (index) => MovieItem(
                            id: '1',
                            title: '123',
                            imageUrl: ImageConstant.imgCard,
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                    child: ListTitleMovie(
                        movies: List.generate(
                          20,
                          (index) => MovieItem(
                            id: '1',
                            title: '123',
                            imageUrl: ImageConstant.imgCard,
                            rating: 4.3,
                            price: 5.5,
                          ),
                        ),
                      ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String asset;
  final bool isActive;
  final VoidCallback onTap;

  const _ModeButton({
    required this.asset,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        asset,
        colorFilter: ColorFilter.mode(
          isActive ? AppColors.primary500 : AppColors.greyscale700,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
