import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:movie_fe/core/app_export.dart';
import 'package:movie_fe/core/constants/app_padding.dart';
import 'package:movie_fe/core/widgets/loading.dart';
import '../application/wishlist_state_notifier.dart';
import 'widgets/wishlist_item.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistState = ref.watch(wishlistStateProvider);

    return Scaffold(
      body: _buildBody(context, ref, wishlistState),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    WishlistState state,
  ) {
    if (state.status == WishlistStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.status == WishlistStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.error}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.warning,
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(wishlistStateProvider.notifier).loadWishlist();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: ResponsivePadding.content(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                ImageConstant.wishlistIcon,
                width: 64,
                height: 64,
                colorFilter: ColorFilter.mode(
                  AppColors.getTextSecondary(context),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your wishlist is empty',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.getText(context),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add movies you want to watch later',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.getTextSecondary(context),
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: context.responsivePadding(
        horizontalPercent: AppPadding.contentHorizontalPercent,
        topPercent: AppPadding.contentVerticalPercent,
        bottomPercent: 0,
      ),
      child: ListView.separated(
        itemBuilder: (context, index) => WishlistItem(
          movie: state.items[index],
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 18),
        itemCount: state.items.length,
      ),
    );
  }
}
