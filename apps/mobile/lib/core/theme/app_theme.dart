import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nozie_mobile/core/extension/lined_text_divider_theme_extensions.dart';
import 'package:nozie_mobile/core/theme/app_colors.dart';
import 'package:nozie_mobile/core/theme/app_spacing.dart';
import 'package:nozie_mobile/core/theme/app_typography.dart';

/// Light and dark themes are built from the same recipe so they cannot drift apart.
abstract final class AppTheme {
  static final ThemeData light = _build(Brightness.light);
  static final ThemeData dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background = isDark ? AppColors.dark1 : AppColors.white;
    final foreground = isDark ? Colors.white : AppColors.greyscale900;
    final line = isDark ? AppColors.dark4 : AppColors.greyscale200;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary500,
        brightness: brightness,
        secondary: isDark ? null : AppColors.secondary500,
        surface: background,
      ),
      extensions: [
        LinedTextDividerTheme(
          lineColor: line,
          textStyle: AppTypography.bodyXLMedium.copyWith(
            color: isDark ? AppColors.greyscale300 : AppColors.greyscale700,
          ),
        ),
      ],
      dividerColor: line,
      textTheme: _textTheme.apply(bodyColor: foreground, displayColor: foreground),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary500,
          foregroundColor: isDark ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
        // Material 3 tints a scrolled-under app bar with the primary colour (a beige band on our
        // orange seed). The bar should stay the page colour.
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: isDark ? _darkOverlay : _lightOverlay,
      ),
    );
  }

  /// Icons on a light page need dark status-bar icons, and vice versa.
  static const _lightOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );
  static const _darkOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  static final TextTheme _textTheme = TextTheme(
    displayLarge: AppTypography.h1,
    displayMedium: AppTypography.h2,
    displaySmall: AppTypography.h3,
    headlineLarge: AppTypography.h4,
    headlineMedium: AppTypography.h5,
    headlineSmall: AppTypography.h6,
    titleLarge: AppTypography.bodyXLRegular,
    titleMedium: AppTypography.bodyXLSemibold,
    titleSmall: AppTypography.bodyXLMedium,
    bodyLarge: AppTypography.bodyLRegular,
    bodyMedium: AppTypography.bodyMRegular,
    bodySmall: AppTypography.bodySBRegular,
    labelLarge: AppTypography.bodyLSemibold,
    labelMedium: AppTypography.bodyMSemibold,
    labelSmall: AppTypography.bodyXSRegular,
  );
}
