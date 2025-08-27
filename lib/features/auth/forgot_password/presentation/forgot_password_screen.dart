import 'package:flutter/material.dart';
import 'package:movie_fe/core/app_export.dart';
import 'package:movie_fe/core/theme/app_colors.dart';
import 'package:movie_fe/routes/app_routers.dart';

import '../../../../l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final type = Theme.of(context).textTheme;
    final TextEditingController _emailController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.forgotPasswordTitle, style: type.displaySmall),

              const SizedBox(height: 12),

              Text(t.forgotPasswordDes, style: type.titleLarge),

              const SizedBox(height: 32),

              Text(
                t.email,
                style: type.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 16),

              InfoField(
                hintText: "admin@ziet.dev",
                controller: _emailController,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_emailController.text.isNotEmpty) {
                      Navigator.pushNamed(
                        context,
                        AppRouters.otpVerification,
                        arguments: _emailController.text,
                      );
                    }
                  },
                  child: Text(t.continueText, style: AppTypography.bodyLBold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
