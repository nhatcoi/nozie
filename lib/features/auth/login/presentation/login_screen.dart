import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_fe/core/app_export.dart';
import 'package:movie_fe/core/widgets/lined_text_divider.dart';
import 'package:movie_fe/core/widgets/social_button.dart';
import 'package:movie_fe/features/auth/login/presentation/providers/login_provider.dart';
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

    final userCtl = ref.watch(usernameControllerProvider);
    final passCtl = ref.watch(passwordControllerProvider);
    final userNode = ref.watch(userFocusProvider);
    final passNode = ref.watch(passFocusProvider);


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: GestureDetector(
          behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
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

                InfoField(
                  hintText: "admin@ziet.dev",
                  controller: userCtl,
                  focusNode: userNode,
                  onSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(passNode),
                ),

                const SizedBox(height: 24),

                InfoField(hintText: "●●●●●●●●●●●●", isPassword: true,
                controller: passCtl,
                focusNode: passNode,
                onSubmitted: (_) => FocusScope.of(context).unfocus()),

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
                    onTap: () {
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
                        icon: SvgPicture.asset(
                          ImageConstant.imgGoogleIcon,
                          height: 24,
                        ),
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
                  onPressed: () {
                    if(userCtl.text.isNotEmpty && passCtl.text.isNotEmpty) {
                      Navigator.pushNamed(context, AppRouters.home);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(t.fillAllFields))
                      );
                    }

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
