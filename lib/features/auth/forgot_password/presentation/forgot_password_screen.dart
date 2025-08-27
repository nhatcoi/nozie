import 'package:flutter/material.dart';
import 'package:movie_fe/core/app_export.dart';
import 'package:movie_fe/core/theme/app_colors.dart';
import 'package:movie_fe/routes/app_routers.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.i18n;
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
              Text(t.auth.forgotPassword.title, style: type.displaySmall),

              const SizedBox(height: 12),

              Text(t.auth.forgotPassword.description, style: type.titleLarge),

              const SizedBox(height: 32),

              Text(
                t.auth.email,
                style: type.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 16),

              InfoField(
                hintText: t.auth.loginScreen.placeholder.email,
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
                  child: Text(t.common.continueText, style: AppTypography.bodyLBold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
