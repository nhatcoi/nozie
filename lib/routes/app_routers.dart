import 'package:flutter/material.dart';
import 'package:movie_fe/features/auth/login/presentation/login_screen.dart';
import '../features/auth/register/presentation/screen/signup_flow_screen.dart';
import '../features/auth/welcome/welcome_screen.dart';
import '../features/setting/presentation/screens/home_screen.dart';
import '../core/services/locale_setting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppRouters {
  static const String welcome = '/';
  static const String signup = '/signup';
  static const String login = '/login';
  static const String home = '/home';
  static const String setting = '/setting';
  static const String resetPassword = '/reset-password';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgotPassword';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name;
    
    if (name == null || name == welcome) {
      return MaterialPageRoute(
        builder: (_) => const WelcomeScreen(),
      );
    } 
    
    if (name == signup) {
      return MaterialPageRoute(
        builder: (_) => const SignupFlowScreen(),
      );
    }
    if (name == login) {
      return MaterialPageRoute(
        builder: (_) => const LoginScreen()
      );
    }
    
    if (name == home) {
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Home'),
          ),
        ),
      );
    }

    if (name == setting) {
      return MaterialPageRoute(
        builder: (context) {
          return Consumer(
              builder: (context, ref, child) {
                final locale = ref.watch(localeControllerProvider);
                return SettingPage(
                  locale,
                      (newLocale) {
                    ref.read(localeControllerProvider.notifier).setLocale(newLocale);
                  },
                );
              }
          );
        },
      );
    }
    
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Route not found'),
        ),
      ),
    );
  }
}
