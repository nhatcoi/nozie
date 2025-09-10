import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:movie_fe/core/app_export.dart';
import '../../application/search_state_notifier.dart';
import '../../entities/search_result.dart';

class SearchBody extends ConsumerStatefulWidget {
  const SearchBody({super.key});

  @override
  ConsumerState<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends ConsumerState<SearchBody> {
  late final searchState = ref.watch(searchStateProvider);

  @override
  Widget build(BuildContext context) {
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

        Flexible(
          child: searchState.showInMode == ShowInMode.category
              ? _buildCategoryView(context, searchState)
              : _buildDocumentView(context, searchState),
        ),
      ],
    );
  }


  // test
  Widget _buildCategoryView(BuildContext context, SearchState searchState) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount:
      searchState.results.length + (searchState.hasMoreResults ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == searchState.results.length) {
          // Load more button
          return _buildLoadMoreButton(context, searchState);
        }
        return _buildCategoryCard(context, searchState.results[index]);
      },
    );
  }

  Widget _buildDocumentView(BuildContext context, SearchState searchState) {
    return ListView.separated(
      itemCount:
      searchState.results.length + (searchState.hasMoreResults ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == searchState.results.length) {
          // Load more button
          return _buildLoadMoreButton(context, searchState);
        }
        return _buildSearchResultCard(context, searchState.results[index]);
      },
    );
  }

  Widget _buildLoadMoreButton(BuildContext context, SearchState searchState) {
    return Center(
      child: searchState.isLoadingMore
          ? const Padding(
        padding: EdgeInsets.all(16),
        child: LoadingCustom(
          // loading custom widget
          assetName: ImageConstant.loadingIcon,
          size: 60,
          color: AppColors.primary500,
        ),
      )
          : ElevatedButton(
        onPressed: () {
          ref.read(searchStateProvider.notifier).loadMoreResults();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary500,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Load More',
          style: AppTypography.bodySBRegular.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  Widget _buildCategoryCard(BuildContext context, SearchResult result) {
    return GestureDetector(
      onTap: () {
        // Navigate to movie detail
        // context.push('/movie/${result.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.getSurface(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.getTextSecondary(context).withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie poster
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: result.imageUrl != null
                    ? Image.network(
                  result.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.getTextSecondary(
                      context,
                    ).withOpacity(0.1),
                    child: Icon(
                      Icons.movie,
                      color: AppColors.getTextSecondary(context),
                      size: 40,
                    ),
                  ),
                )
                    : Container(
                  color: AppColors.getTextSecondary(
                    context,
                  ).withOpacity(0.1),
                  child: Icon(
                    Icons.movie,
                    color: AppColors.getTextSecondary(context),
                    size: 40,
                  ),
                ),
              ),
            ),
            // Movie info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title,
                      style: AppTypography.bodyMMedium.copyWith(
                        color: AppColors.getText(context),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (result.rating != null) ...[
                      Row(
                        children: [
                          Icon(Icons.star, size: 12, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            result.rating!.toStringAsFixed(1),
                            style: AppTypography.bodyXSMedium.copyWith(
                              color: AppColors.getText(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSearchResultCard(BuildContext context, SearchResult result) {
    return GestureDetector(
      onTap: () {
        // Navigate to movie detail
        // context.push('/movie/${result.id}');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.getSurface(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.getTextSecondary(context).withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            // Movie poster
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: result.imageUrl != null
                  ? Image.network(
                result.imageUrl!,
                width: 60,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 90,
                  color: AppColors.getTextSecondary(
                    context,
                  ).withOpacity(0.1),
                  child: Icon(
                    Icons.movie,
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
              )
                  : Container(
                width: 60,
                height: 90,
                color: AppColors.getTextSecondary(
                  context,
                ).withOpacity(0.1),
                child: Icon(
                  Icons.movie,
                  color: AppColors.getTextSecondary(context),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Movie info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    style: AppTypography.h6.copyWith(
                      color: AppColors.getText(context),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (result.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      result.subtitle!,
                      style: AppTypography.bodyMMedium.copyWith(
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (result.rating != null) ...[
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          result.rating!.toStringAsFixed(1),
                          style: AppTypography.bodyXSMedium.copyWith(
                            color: AppColors.getText(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (result.releaseYear != null) ...[
                        Text(
                          result.releaseYear!,
                          style: AppTypography.bodyMMedium.copyWith(
                            color: AppColors.getTextSecondary(context),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (result.genres.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      result.genres.take(2).join(', '),
                      style: AppTypography.bodyXSMedium.copyWith(
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Type indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                result.type.name.toUpperCase(),
                style: AppTypography.bodyMMedium.copyWith(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}