import 'package:flutter/material.dart';
import 'package:movie_fe/l10n/app_localizations.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final type = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.loginTitle, style: type.displaySmall),

              const SizedBox(height: 12),

              Text(t.loginDescription,style: type.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
