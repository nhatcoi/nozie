import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nozie_mobile/core/app_export.dart';
import 'package:nozie_mobile/features/auth/forgot_password/providers/forgot_password_repository_provider.dart';
import 'package:nozie_mobile/app/router/app_router.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.i18n;
    final type = Theme.of(context).textTheme;
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
                keyboardType: TextInputType.emailAddress,
                validator: (value) => ValidationUtils.validateEmail(value, context),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    if (email.isEmpty) return;

                    try {
                      final repo = ref.read(forgotPasswordRepositoryProvider);
                      await repo.resendOtp(email: email);
                    } catch (_) {}
                    if (!context.mounted) return;
                    context.push(AppRouter.otpVerification, extra: email);
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
