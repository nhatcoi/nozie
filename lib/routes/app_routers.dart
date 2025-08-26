import 'package:flutter/material.dart';
import 'package:movie_fe/features/auth/forgot_password/presentation/forgot_password_new_pass_screen.dart';
import 'package:movie_fe/features/auth/forgot_password/presentation/forgot_password_otp_screen.dart';
import 'package:movie_fe/features/auth/forgot_password/presentation/forgot_password_screen.dart';
import 'package:movie_fe/features/auth/login/presentation/login_screen.dart';
import '../features/auth/register/presentation/screen/signup_flow_screen.dart';
import '../features/auth/welcome/welcome_screen.dart';
import '../features/setting/presentation/screens/home_screen.dart';
import '../core/services/locale_setting.dart';

class AppRouters {
  static const String welcome = '/';
  static const String signup = '/signup';
  static const String signIn = '/sign-in';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String resetPassword = '/reset-password';

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
    if (name == signIn) {
      return MaterialPageRoute(
        builder: (_) => const LoginScreen()
      );
    }

    if (name == forgotPassword) {
      return MaterialPageRoute(
        builder: (_) => const ForgotPasswordScreen(),
      );
    }

    if (name == otpVerification) {
      final email = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => ForgotPasswordOtpScreen(email: email),
      );
    }

    if (name == resetPassword) {
      return MaterialPageRoute(
        builder: (_) => ForgotPasswordNewPassScreen(),
      );
    }
    
    if (name == home) {
      return MaterialPageRoute(
        builder: (context) {
          // Get locale from context
          final locale = Localizations.localeOf(context);
          return HomePage(
            locale,
            (newLocale) {
              // Handle locale change - you might want to use a provider here
              print('Locale changed to: ${newLocale.languageCode}');
            },
          );
        },
      );
    }
    
    if (name == settings) {
      return MaterialPageRoute(
        builder: (context) {
          // Get locale from context
          final locale = Localizations.localeOf(context);
          return HomePage(
            locale,
            (newLocale) {
              // Handle locale change - you might want to use a provider here
              print('Locale changed to: ${newLocale.languageCode}');
            },
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
