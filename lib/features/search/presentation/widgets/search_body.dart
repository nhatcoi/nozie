import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:movie_fe/core/app_export.dart';
import 'package:movie_fe/core/enums/movie_type.dart';
import 'package:movie_fe/core/widgets/cards/movie_card.dart';
import 'package:movie_fe/core/widgets/lists/list_title_movie.dart';
import 'package:movie_fe/core/widgets/loading.dart';
import '../../../../core/models/movie_item.dart';
import '../../../../routes/app_router.dart';
import '../../application/search_state_notifier.dart';
import '../../entities/search_result.dart';

class SearchBody extends ConsumerStatefulWidget {
  const SearchBody({super.key});

  @override
  ConsumerState<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends ConsumerState<SearchBody> {
  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchStateProvider);

    if (searchState.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImageConstant.searchIcon,
              width: 64,
              height: 64,
              colorFilter: ColorFilter.mode(
                AppColors.getTextSecondary(context),
                BlendMode.srcIn,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              context.i18n.search.noResults,
              style: AppTypography.h5.copyWith(
                color: AppColors.getText(context),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Try searching with different keywords',
              style: AppTypography.bodyLRegular.copyWith(
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.i18n.search.showIn,
              style: AppTypography.h5.copyWith(
                color: AppColors.getText(context),
                fontWeight: FontWeight.w700,
              ),
            ),

            Row(
              children: [
                IconButton(
                  onPressed: () {
                    ref
                        .read(searchStateProvider.notifier)
                        .setShowInMode(ShowInMode.category);
                  },
                  icon: SvgPicture.asset(
                    ImageConstant.categoryIcon,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      searchState.showInMode == ShowInMode.category
                          ? AppColors.primary500
                          : AppColors.getText(context),
                      BlendMode.srcIn,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    ref
                        .read(searchStateProvider.notifier)
                        .setShowInMode(ShowInMode.document);
                  },
                  icon: SvgPicture.asset(
                    ImageConstant.documentIcon,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      searchState.showInMode == ShowInMode.document
                          ? AppColors.primary500
                          : AppColors.getText(context),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Main content
        Expanded(
          child: searchState.showInMode == ShowInMode.category
              ? _buildCategoryView(context, searchState)
              : _buildDocumentView(context, searchState),
        ),
      ],
    );
  }

  Widget _buildCategoryView(BuildContext context, SearchState searchState) {
    // Grid view (2 columns) of MovieCard
    final items = searchState.results
        .map(
          (result) => MovieItem(
            id: result.id,
            title: result.title,
            imageUrl: ImageConstant.imgCard,
            rating: result.rating,
            price: 5.5,
          ),
        )
        .toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 180 / 370,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final movie = items[index];
        return MovieCard(movie: movie);
      },
    );
  }

  Widget _buildDocumentView(BuildContext context, SearchState searchState) {
    // List view using ListTitleMovie
    final movieItems = searchState.results
        .map(
          (result) => MovieItem(
            id: result.id,
            title: result.title,
            imageUrl: ImageConstant.imgCard,
            rating: result.rating,
            price: 5.5,
          ),
        )
        .toList();

    return ListTitleMovie(movies: movieItems);
  }

  // Widget _buildLoadMoreButton(BuildContext context, SearchState searchState) {
  //   return Center(
  //     child: searchState.isLoadingMore
  //         ? const Padding(
  //       padding: EdgeInsets.all(16),
  //       child: LoadingCustom(
  //         // loading custom widget
  //         assetName: ImageConstant.loadingIcon,
  //         size: 60,
  //         color: AppColors.primary500,
  //       ),
  //     )
  //         : ElevatedButton(
  //       onPressed: () {
  //         ref.read(searchStateProvider.notifier).loadMoreResults();
  //       },
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: AppColors.primary500,
  //         foregroundColor: Colors.white,
  //         padding: const EdgeInsets.symmetric(
  //           horizontal: 24,
  //           vertical: 12,
  //         ),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //       ),
  //       child: Text(
  //         'Load More',
  //         style: AppTypography.bodySBRegular.copyWith(
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
