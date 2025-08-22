import 'package:flutter/material.dart';

class AppTypography {
  // base style
  static const _regular  = TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w400);
  static const _medium   = TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w500);
  static const _semibold = TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w600);
  static const _bold     = TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w700);

  // ==== Headings ====
  static TextStyle get h1 => _bold.copyWith(fontSize: 48, height: 1.15);
  static TextStyle get h2 => _bold.copyWith(fontSize: 40, height: 1.15);
  static TextStyle get h3 => _bold.copyWith(fontSize: 32, height: 1.20);
  static TextStyle get h4 => _bold.copyWith(fontSize: 24, height: 1.25);
  static TextStyle get h5 => _bold.copyWith(fontSize: 20, height: 1.30);
  static TextStyle get h6 => _bold.copyWith(fontSize: 18, height: 1.30);

  // ==== Body XLarge (18px) ====
  static TextStyle get bodyXLBold     => _bold.copyWith(fontSize: 18, height: 1.40);
  static TextStyle get bodyXLSemibold => _semibold.copyWith(fontSize: 18, height: 1.40);
  static TextStyle get bodyXLMedium   => _medium.copyWith(fontSize: 18, height: 1.40);
  static TextStyle get bodyXLRegular  => _regular.copyWith(fontSize: 18, height: 1.40);

  // ==== Body Large (16px) ====
  static TextStyle get bodyLBold     => _bold.copyWith(fontSize: 16, height: 1.40);
  static TextStyle get bodyLSemibold => _semibold.copyWith(fontSize: 16, height: 1.40);
  static TextStyle get bodyLMedium   => _medium.copyWith(fontSize: 16, height: 1.40);
  static TextStyle get bodyLRegular  => _regular.copyWith(fontSize: 16, height: 1.40);

  // ==== Body Medium (14px) ====
  static TextStyle get bodyMBold     => _bold.copyWith(fontSize: 14, height: 1.45);
  static TextStyle get bodyMSemibold => _semibold.copyWith(fontSize: 14, height: 1.45);
  static TextStyle get bodyMMedium   => _medium.copyWith(fontSize: 14, height: 1.45);
  static TextStyle get bodyMRegular  => _regular.copyWith(fontSize: 14, height: 1.45);

  // ==== Body Small (12px) ====
  static TextStyle get bodySBBold     => _bold.copyWith(fontSize: 12, height: 1.45);
  static TextStyle get bodySBSemibold => _semibold.copyWith(fontSize: 12, height: 1.45);
  static TextStyle get bodySBMedium   => _medium.copyWith(fontSize: 12, height: 1.45);
  static TextStyle get bodySBRegular  => _regular.copyWith(fontSize: 12, height: 1.45);

  // ==== Body XSmall (10px) ====
  static TextStyle get bodyXSBold     => _bold.copyWith(fontSize: 10, height: 1.40);
  static TextStyle get bodyXSSemibold => _semibold.copyWith(fontSize: 10, height: 1.40);
  static TextStyle get bodyXSMedium   => _medium.copyWith(fontSize: 10, height: 1.40);
  static TextStyle get bodyXSRegular  => _regular.copyWith(fontSize: 10, height: 1.40);
}
