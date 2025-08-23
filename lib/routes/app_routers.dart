import 'package:flutter/material.dart';
import '../features/auth/register/presentation/screen/signup_flow_screen.dart';
import '../features/auth/welcome/welcome_screen.dart';

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

    // TODO: Implement login screen
    if (name == login) {
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Login Screen - Coming Soon'),
          ),
        ),
      );
    }
    
    if (name == home) {
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Home Screen - Coming Soon'),
          ),
        ),
      );
    }
    
    if (name == settings) {
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Settings Screen - Coming Soon'),
          ),
        ),
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
