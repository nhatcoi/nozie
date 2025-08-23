import 'package:flutter/material.dart';
import 'package:movie_fe/core/theme/app_colors.dart';
import 'package:movie_fe/core/theme/app_typography.dart';

import '../../../l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final type = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(24,16,24,48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(t.forgotPasswordTitle, style: type.displaySmall),

          const SizedBox(height: 12),

          Text(t.forgotPasswordDes, style: type.titleLarge),

          const SizedBox(height: 32),

          Text(t.email, style: type.labelLarge?.copyWith(fontWeight: FontWeight.w700)),

          const SizedBox(height: 16),

          TextField(
            decoration: InputDecoration(
              hintText: "admin@ziet.dev",
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black, // đổi màu nếu cần
              ),
              border: InputBorder.none, // bỏ viền mặc định
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary500, width: 2),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary500, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(t.continueText,style: AppTypography.bodyLBold),
            ),
          ),


        ],
      ),
      )),
    );
  }
}
