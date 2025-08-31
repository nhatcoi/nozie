import 'package:flutter/material.dart';

class CustomNoTransitionPage extends Page {
  final Widget child;

  const CustomNoTransitionPage({
    super.key,
    required this.child,
  });

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}
