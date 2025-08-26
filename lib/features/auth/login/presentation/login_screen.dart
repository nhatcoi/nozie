import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_fe/core/app_export.dart';
import 'package:movie_fe/core/widgets/lined_text_divider.dart';
import 'package:movie_fe/core/widgets/social_button.dart';
import 'package:movie_fe/l10n/app_localizations.dart';
import 'package:movie_fe/core/widgets/app_checkbox.dart';

import '../../../../routes/app_routers.dart';

final rememberMeProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var rememberMe = ref.watch(rememberMeProvider);
    final t = AppLocalizations.of(context)!;
    final ctx = Theme.of(context);
    final type = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
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

              Text(t.loginDescription, style: type.titleLarge),

              const SizedBox(height: 32),

              Text(
                '${t.username} / ${t.email}',
                style: type.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),

              InfoField(hintText: "admin@ziet.dev"),

              const SizedBox(height: 24),

              InfoField(hintText: "●●●●●●●●●●●●", isPassword: true),

              const SizedBox(height: 24),

              AppCheckbox(
                value: rememberMe,
                label: t.rememberMe,
                textStyle: type.titleMedium,
                spacing: 16,
                onChanged: (bool value) {
                  ref.read(rememberMeProvider.notifier).state = value;
                },
              ),

              const SizedBox(height: 24),

              LinedTextDivider(),

              const SizedBox(height: 24),

              Container(
                width: double.infinity, // full width
                alignment: Alignment.center, // căn giữa text
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, AppRouters.forgotPassword);
                  },
                  child: Text(
                    t.forgotPassword,
                    style: type.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              LinedTextDivider(text: t.orContinueWith),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: SocialButton(
                      icon: SvgPicture.asset(ImageConstant.imgGoogleIcon, height: 24),
                      onPressed: () {
                        // TODO: Google login
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SocialButton(
                      icon: Icon(
                        Icons.apple,
                        size: 28,
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                      onPressed: () {
                        // TODO: Apple login
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SocialButton(
                      icon: SvgPicture.asset(
                        ImageConstant.imgFBIcon,
                        height: 24,
                      ),
                      onPressed: () {
                        // TODO: Facebook login
                      },
                    ),
                  ),
                ],
              ),

              const Spacer(),

              PrimaryButton(
                  text: t.signIn,
                  onPressed: (){
                    Navigator.pushNamed(context, AppRouters.home);
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
