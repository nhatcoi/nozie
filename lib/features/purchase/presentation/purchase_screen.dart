import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/app_export.dart';
import '../../../../core/constants/app_padding.dart';
import '../application/purchase_state_notifier.dart';
import 'widgets/purchase_item.dart';

class PurchaseScreen extends ConsumerWidget {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseState = ref.watch(purchaseStateProvider);

    return Scaffold(
      body: _buildBody(context, ref, purchaseState),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    PurchaseState state,
  ) {
    if (state.status == PurchaseStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.status == PurchaseStatus.error) {
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
                ref.read(purchaseStateProvider.notifier).loadPurchasedItems();
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
                ImageConstant.purchaseIcon,
                width: 64,
                height: 64,
                colorFilter: ColorFilter.mode(
                  AppColors.getTextSecondary(context),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your purchased library is empty',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.getText(context),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Purchase books to add them to your library',
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
        itemBuilder: (context, index) => PurchaseItemWidget(
          item: state.items[index],
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 18),
        itemCount: state.items.length,
      ),
    );
  }
}
