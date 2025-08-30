import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../theme/app_colors.dart';
import '../../routes/app_router.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;
  final bool showAppBar;
  final bool showBottomNav;
  final List<Widget>? actions;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSearchTap;

  const MainLayout({
    super.key,
    required this.child,
    this.showAppBar = true,
    this.showBottomNav = true,
    this.actions,
    this.onNotificationTap,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPath = GoRouterState.of(context).uri.toString();
    final currentIndex = _getCurrentIndex(currentPath);
    final currentTitle = _getCurrentTitle(currentPath);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: showAppBar 
          ? CustomAppBar(
              title: currentTitle,
              actions: actions,
              onNotificationTap: onNotificationTap,
              onSearchTap: onSearchTap,
            )
          : null,
      body: child,
      bottomNavigationBar: showBottomNav 
          ? CustomBottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.go(AppRouter.home);
                    break;
                  case 1:
                    context.go(AppRouter.discover);
                    break;
                  case 2:
                    context.go(AppRouter.wishlist);
                    break;
                  case 3:
                    context.go(AppRouter.buy);
                    break;
                  case 4:
                    context.go(AppRouter.profile);
                    break;
                }
              },
            )
          : null,
    );
  }

  int _getCurrentIndex(String path) {
    switch (path) {
      case AppRouter.home:
        return 0;
      case AppRouter.discover:
        return 1;
      case AppRouter.wishlist:
        return 2;
      case AppRouter.buy:
        return 3;
      case AppRouter.profile:
        return 4;
      default:
        return 0;
    }
  }

  String _getCurrentTitle(String path) {
    switch (path) {
      case AppRouter.home:
        return 'NoZie';
      case AppRouter.discover:
        return 'Discover';
      case AppRouter.wishlist:
        return 'Wishlist';
      case AppRouter.buy:
        return 'Buy';
      case AppRouter.profile:
        return 'Profile';
      default:
        return 'NoZie';
    }
  }
}
