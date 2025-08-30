import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_fe/features/auth/forgot_password/presentation/forgot_password_new_pass_screen.dart';
import 'package:movie_fe/features/auth/forgot_password/presentation/forgot_password_otp_screen.dart';
import 'package:movie_fe/features/auth/forgot_password/presentation/forgot_password_screen.dart';
import 'package:movie_fe/features/auth/login/presentation/login_screen.dart';
import '../features/auth/register/presentation/screen/signup_flow_screen.dart';
import '../features/auth/welcome/welcome_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/discover/presentation/screens/discover_screen.dart';
import '../core/layouts/main_layout.dart';

class AppRouter {
  static const String welcome = '/';
  static const String signup = '/signup';
  static const String signIn = '/sign-in';
  static const String home = '/home';
  static const String discover = '/discover';
  static const String wishlist = '/wishlist';
  static const String buy = '/buy';
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
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: discover,
            builder: (context, state) => const DiscoverScreen(),
          ),
          GoRoute(
            path: wishlist,
            builder: (context, state) => const _PlaceholderScreen(title: 'Wishlist', icon: Icons.favorite),
          ),
          GoRoute(
            path: buy,
            builder: (context, state) => const _PlaceholderScreen(title: 'Buy', icon: Icons.shopping_cart),
          ),
          GoRoute(
            path: profile,
            builder: (context, state) => const _PlaceholderScreen(title: 'Profile', icon: Icons.person),
          ),
        ],
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const MainLayout(
          showAppBar: true,
          showBottomNav: false,
          child: _PlaceholderScreen(title: 'Settings', icon: Icons.settings),
        ),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Route not found'),
      ),
    ),
  );
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
