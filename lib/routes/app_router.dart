import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_fe/features/auth/forgot_password/presentation/forgot_password_new_pass_screen.dart';
import 'package:movie_fe/features/auth/forgot_password/presentation/forgot_password_otp_screen.dart';
import 'package:movie_fe/features/auth/forgot_password/presentation/forgot_password_screen.dart';
import 'package:movie_fe/features/auth/login/presentation/login_screen.dart';
import 'package:movie_fe/features/wishlist/presentation/wishlist_screen.dart';
import '../features/auth/register/presentation/screen/signup_flow_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/discover/presentation/screens/discover_screen.dart';
import '../core/layouts/main_layout.dart';
import '../features/purchase/presentation/purchase_screen.dart';
import '../features/setting/presentation/screens/setting_screen.dart';
import '../core/services/locale_setting.dart';
import '../core/utils/no_transition_page.dart';
import '../features/welcome/welcome_screen.dart';

class AppRouter {
  static const String welcome = '/';
  static const String signup = '/signup';
  static const String signIn = '/sign-in';
  static const String home = '/home';
  static const String discover = '/discover';
  static const String wishlist = '/wishlist';
  static const String purchase = '/purchase';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String resetPassword = '/reset-password';

  static final GoRouter router = GoRouter(
    initialLocation: welcome,
    routes: [
      GoRoute(
        path: welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: signup,
        builder: (context, state) => const SignupFlowScreen(),
      ),
      GoRoute(
        path: signIn,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: otpVerification,
        builder: (context, state) {
          final email = state.extra as String?;
          return ForgotPasswordOtpScreen(email: email ?? '');
        },
      ),
      GoRoute(
        path: resetPassword,
        builder: (context, state) => const ForgotPasswordNewPassScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainLayout(
          showAppBar: true,
          showBottomNav: true,
          child: child,
        ),
        routes: [
          GoRoute(
            path: home,
            pageBuilder: (context, state) => CustomNoTransitionPage( // bỏ hiệu ứng
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: discover,
            pageBuilder: (context, state) => CustomNoTransitionPage(
              child: const DiscoverScreen(),
            ),
          ),
          GoRoute(
            path: wishlist,
            pageBuilder: (context, state) => CustomNoTransitionPage(
              child: const WishlistScreen(),
            ),
          ),
          GoRoute(
            path: purchase,
            pageBuilder: (context, state) => CustomNoTransitionPage(
              child: const PurchaseScreen(),
            ),
          ),
          GoRoute(
            path: profile,
            pageBuilder: (context, state) => CustomNoTransitionPage(
              child: Consumer(
                builder: (context, ref, child) {
                  final currentLocale = ref.watch(localeControllerProvider);
                  final localeController = ref.read(localeControllerProvider.notifier);
                  
                  return SettingPage(
                    currentLocale,
                    (locale) => localeController.setLocale(locale),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Route not found'),
      ),
    ),
  );
}
