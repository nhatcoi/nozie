import 'package:flutter/material.dart';
import 'package:movie_fe/features/auth/login/presentation/login_screen.dart';
import '../features/auth/register/presentation/screen/signup_flow_screen.dart';
import '../features/auth/welcome/welcome_screen.dart';
import '../features/setting/presentation/screens/home_screen.dart';
import '../core/services/locale_setting.dart';

class AppRouters {
  static const String welcome = '/';
  static const String signup = '/signup';
  static const String login = '/login';
  static const String home = '/home';
  static const String settings = '/settings';

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
