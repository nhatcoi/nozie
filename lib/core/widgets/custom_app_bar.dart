import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/image_constant.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSearchTap;

  const CustomAppBar({
    super.key,
    this.title = 'NoZie',
    this.actions,
    this.onNotificationTap,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.getBackground(context),
      centerTitle: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          SvgPicture.asset(
            ImageConstant.logoIcon,
            width: 100,
            height: 100,
          ),

          const SizedBox(width: 8),

          Text(
            title,
            style: AppTypography.h5.copyWith(
              color: AppColors.getText(context),
              fontWeight: FontWeight.w600,
            ),
          ),

        ],
      ),

      actions: [
        Container(
          margin: const EdgeInsets.all(8),

          child: IconButton(
            icon: SvgPicture.asset(
              ImageConstant.searchIcon,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                AppColors.getText(context),
                BlendMode.srcIn,
              ),
            ),
            onPressed: onSearchTap ?? () {
              // Default search tap handler
            },
          ),
        ),
        if (actions != null) ...actions!,
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
