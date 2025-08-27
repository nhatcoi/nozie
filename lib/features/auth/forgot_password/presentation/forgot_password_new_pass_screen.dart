import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_fe/core/app_export.dart';
import 'package:movie_fe/core/widgets/app_checkbox.dart';

import '../../../../core/widgets/modal.dart';

final rememberMeProvider = StateProvider<bool>((ref) => false);

class ForgotPasswordNewPassScreen extends ConsumerWidget {
  const ForgotPasswordNewPassScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var rememberMe = ref.watch(rememberMeProvider);
    final t = context.i18n;
    final ctxTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.auth.forgotPassword.newPassword.title, style: ctxTheme.displaySmall),

              const SizedBox(height: 12),

              Text(t.auth.forgotPassword.newPassword.description, style: ctxTheme.titleLarge),

              const SizedBox(height: 32),

              Text(
                t.auth.password,
                style: ctxTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 16),

              InfoField(hintText: '●●●●●●●●●●●●', isPassword: true),

              const SizedBox(height: 24),

              Text(
                t.auth.confirmPassword,
                style: ctxTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 16),

              InfoField(hintText: '●●●●●●●●●●●●', isPassword: true),

              const SizedBox(height: 24),

              AppCheckbox(
                value: rememberMe,
                label: t.auth.rememberMe,
                textStyle: ctxTheme.titleMedium,
                spacing: 16,
                onChanged: (bool value) {
                  ref.read(rememberMeProvider.notifier).state = value;
                },
              ),

              const Spacer(),

              PrimaryButton(
                text: t.common.continueText,
                onPressed: () async {
                  await showAppModal(
                    context: context,
                    title: 'Error',
                    description: 'Error',
                    iconPath: ImageConstant.successIcon,
                    primaryButton: PrimaryButton(
                      text: 'Close',
                      onPressed: () => Navigator.pop(context),
                    ),
                    secondaryButton: SecondaryButton(
                      text: 'ok',
                      onPressed: () => Navigator.pop(context),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
