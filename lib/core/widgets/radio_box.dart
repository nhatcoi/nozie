import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class RadioBox extends StatelessWidget {
  final String title;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final Color? borderColor;
  final Color? selectedBorderColor;
  final double borderWidth;
  final Color? textColor;
  final Color? selectedTextColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double radioSize;
  final double radioBorderWidth;
  final Color? radioBorderColor;
  final Color? selectedRadioBorderColor;
  final double innerDotSize;
  final Color? innerDotColor;
  final Duration animationDuration;
  final Curve animationCurve;

  const RadioBox({
    super.key,
    required this.title,
    required this.value,
    required this.isSelected,
    required this.onTap,
    this.width,
    this.height = 60,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    this.borderRadius = 16,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.borderColor,
    this.selectedBorderColor,
    this.borderWidth = 0,
    this.textColor,
    this.selectedTextColor,
    this.fontSize = 16,
    this.fontWeight,
    this.radioSize = 24,
    this.radioBorderWidth = 3,
    this.radioBorderColor,
    this.selectedRadioBorderColor,
    this.innerDotSize = 12,
    this.innerDotColor,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: animationDuration,
        curve: animationCurve,
        width: width ?? double.infinity,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: borderWidth > 0 ? Border.all(
            color: isSelected
                ? (selectedBorderColor ?? AppColors.primary500)
                : (borderColor ?? AppColors.greyscale200),
            width: borderWidth,
          ) : null,
        ),
        child: Row(
          children: [
            // Radio button visual
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: radioSize,
              height: radioSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? (selectedRadioBorderColor ?? AppColors.primary500)
                      : (radioBorderColor ?? AppColors.greyscale300),
                  width: radioBorderWidth,
                ),
                color: Colors.white,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isSelected
                    ? Center(
                  key: const ValueKey('selected'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: innerDotSize,
                    height: innerDotSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: innerDotColor ?? AppColors.primary500,
                    ),
                  ),
                )
                    : const SizedBox.shrink(key: ValueKey('unselected')),
              ),
            ),
            const SizedBox(width: 16),

            // Title
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTypography.bodyLSemibold.copyWith(
                  color: AppColors.greyscale900,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
                child: Text(title),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
