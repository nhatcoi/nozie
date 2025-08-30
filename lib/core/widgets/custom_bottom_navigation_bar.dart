import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/image_constant.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.getSurface(context),
          selectedItemColor: AppColors.primary500,
          unselectedItemColor: AppColors.getTextSecondary(context),
          selectedLabelStyle: AppTypography.bodySBRegular.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTypography.bodySBRegular,
          elevation: 0,
          items: _buildBottomNavItems(context),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavItems(BuildContext context) {
    return [
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          ImageConstant.homeIcon,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            currentIndex == 0 
                ? AppColors.primary500 
                : AppColors.getTextSecondary(context),
            BlendMode.srcIn,
          ),
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          ImageConstant.discoverIcon,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            currentIndex == 1 
                ? AppColors.primary500 
                : AppColors.getTextSecondary(context),
            BlendMode.srcIn,
          ),
        ),
        label: 'Discover',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          ImageConstant.wishlistIcon,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            currentIndex == 2 
                ? AppColors.primary500 
                : AppColors.getTextSecondary(context),
            BlendMode.srcIn,
          ),
        ),
        label: 'Wishlist',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          ImageConstant.buyIcon,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            currentIndex == 3 
                ? AppColors.primary500 
                : AppColors.getTextSecondary(context),
            BlendMode.srcIn,
          ),
        ),
        label: 'Buy',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          ImageConstant.profileIcon,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            currentIndex == 4 
                ? AppColors.primary500 
                : AppColors.getTextSecondary(context),
            BlendMode.srcIn,
          ),
        ),
        label: 'Profile',
      ),
    ];
  }
}
