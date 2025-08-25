import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../util/image_constant.dart';
import 'primary_button.dart';
import 'secondary_button.dart';

class Modal extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;

  final PrimaryButton? primaryButton;
  final SecondaryButton? secondaryButton;

  final EdgeInsetsGeometry contentPadding;
  final double iconSize;

  const Modal({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    this.primaryButton,
    this.secondaryButton,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 40.0, horizontal: 32.0),
    this.iconSize = 141.0,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = AppColors.getText(context);
    final Color textSecondary = AppColors.getTextSecondary(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Padding(
        padding: contentPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: iconSize,
              height: iconSize,
            ),

            const SizedBox(height: 24.0),

            Text(
              title,
              style: AppTypography.h3.copyWith(
                color: textColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16.0),

            Text(
              description,
              style: AppTypography.bodyLRegular.copyWith(
                color: textSecondary,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),

            if (primaryButton != null || secondaryButton != null) ...[
              const SizedBox(height: 32),
              if (primaryButton != null) SizedBox(width: double.infinity, child: primaryButton!),
              if (secondaryButton != null) ...[
                const SizedBox(height: 16),
                SizedBox(width: double.infinity, child: secondaryButton!),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

Future<T?> showAppModal<T>({
  required BuildContext context,
  required String title,
  required String description,
  String iconPath = ImageConstant.loadingIcon,
  PrimaryButton? primaryButton,
  SecondaryButton? secondaryButton,
  bool barrierDismissible = false,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (ctx) => Modal(
      title: title,
      description: description,
      iconPath: iconPath,
      primaryButton: primaryButton,
      secondaryButton: secondaryButton,
    ),
  );
}
