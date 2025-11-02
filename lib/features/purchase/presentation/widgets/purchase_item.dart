import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import '../../../../core/app_export.dart';
import '../../models/purchase_item.dart' as purchase_model;
import '../../application/purchase_state_notifier.dart';

enum PurchaseAction {
  removeDownload,
  viewSeries,
  markAsFinished,
  aboutEbook,
}

class PurchaseItemWidget extends ConsumerStatefulWidget {
  const PurchaseItemWidget({
    super.key,
    required this.item,
  });

  final purchase_model.PurchaseItem item;

  @override
  ConsumerState<PurchaseItemWidget> createState() => _PurchaseItemWidgetState();
}

class _PurchaseItemWidgetState extends ConsumerState<PurchaseItemWidget> {
  final GlobalKey _buttonKey = GlobalKey();

  void _showActionMenu(BuildContext context, WidgetRef ref) {
    final RenderBox? button =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (button == null) return;

    final buttonPosition = button.localToGlobal(Offset.zero);
    final buttonSize = button.size;
    final screenSize = MediaQuery.of(context).size;
    final textColor = AppColors.getText(context);
    final secondaryText = AppColors.getTextSecondary(context);
    final modalBackground = AppColors.getModalBackground(context);
    final theme = Theme.of(context);

    const menuWidth = 200.0;
    final buttonRight = buttonPosition.dx + buttonSize.width;
    final menuLeft = (buttonRight - menuWidth).clamp(8.0, screenSize.width - menuWidth - 8);
    final menuTop = buttonPosition.dy + buttonSize.height + 8;
    final menuRight = screenSize.width - menuLeft - menuWidth;

    showMenu<PurchaseAction>(
      context: context,
      useRootNavigator: true,
      color: modalBackground,
      position: RelativeRect.fromLTRB(
        menuLeft,
        menuTop,
        menuRight,
        menuTop,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      items: [
        PopupMenuItem<PurchaseAction>(
          value: PurchaseAction.removeDownload,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SvgPicture.asset(
                  ImageConstant.paperNegativeIcon,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    textColor,
                    BlendMode.srcIn,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    'Remove Download',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem<PurchaseAction>(
          value: PurchaseAction.viewSeries,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SvgPicture.asset(
                  ImageConstant.listCategoryIcon,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    textColor,
                    BlendMode.srcIn,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    'View Series',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem<PurchaseAction>(
          value: PurchaseAction.markAsFinished,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SvgPicture.asset(
                  ImageConstant.imgCheckedIcon,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    textColor,
                    BlendMode.srcIn,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    'Mark as Finished',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem<PurchaseAction>(
          value: PurchaseAction.aboutEbook,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SvgPicture.asset(
                  ImageConstant.infoSquareIcon,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    textColor,
                    BlendMode.srcIn,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    'About Ebook',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value != null && context.mounted) {
        _handleAction(context, ref, value);
      }
    });
  }

  void _handleAction(
    BuildContext context,
    WidgetRef ref,
    PurchaseAction action,
  ) {
    switch (action) {
      case PurchaseAction.removeDownload:
        ref.read(purchaseStateProvider.notifier).removeDownload(widget.item.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Download removed'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        break;
      case PurchaseAction.viewSeries:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('View series - coming soon'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        break;
      case PurchaseAction.markAsFinished:
        ref.read(purchaseStateProvider.notifier).markAsFinished(widget.item.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Marked as finished'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        break;
      case PurchaseAction.aboutEbook:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('About ebook - coming soon'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = AppColors.getText(context);
    final secondaryText = AppColors.getTextSecondary(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            widget.item.imageUrl,
            width: 80,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: textColor,
                ),
              ),
              if (widget.item.rating != null) ...[
                const Gap(8),
                Row(
                  children: [
                    SvgPicture.asset(
                      ImageConstant.groupIcon,
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        secondaryText,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      widget.item.rating.toString(),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
              const Gap(8),
              Text(
                'Purchased',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: secondaryText,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: widget.item.isFinished
                  ? SvgPicture.asset(
                      ImageConstant.imgCheckedIcon,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        AppColors.primary500,
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(
                      Icons.download_outlined,
                      color: secondaryText,
                      size: 24,
                    ),
              onPressed: () {},
            ),
            IconButton(
              key: _buttonKey,
              icon: Icon(
                Icons.more_vert,
                color: secondaryText,
                size: 24,
              ),
              onPressed: () => _showActionMenu(context, ref),
            ),
          ],
        ),
      ],
    );
  }
}

