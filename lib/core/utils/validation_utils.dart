import 'package:flutter/material.dart';
import '../../../../../../core/app_export.dart';

class ValidationUtils {
  static String? validateUsername(String? value, BuildContext context) {
    if (value?.trim().isEmpty ?? true) {
      return context.l10n.usernameRequired;
    }
    if (value!.trim().length < 3) {
      return context.l10n.usernameMinLength;
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
      return context.l10n.usernameInvalidChars;
    }
    return null;
  }

  static String? validateEmail(String? value, BuildContext context) {
    if (value?.trim().isEmpty ?? true) {
      return context.l10n.emailRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!.trim())) {
      return context.l10n.emailInvalid;
    }
    return null;
  }

  static String? validatePassword(String? value, BuildContext context) {
    if (value?.trim().isEmpty ?? true) {
      return context.l10n.passwordRequired;
    }
    if (value!.trim().length < 8) {
      return context.l10n.passwordMinLength;
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value.trim())) {
      return context.l10n.passwordComplexity;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password, BuildContext context) {
    if (value?.trim().isEmpty ?? true) {
      return context.l10n.confirmPasswordRequired;
    }
    if (value!.trim() != password.trim()) {
      return context.l10n.passwordsDoNotMatch;
    }
    return null;
  }

  static String? validateFullName(String? value, BuildContext context) {
    if (value?.trim().isEmpty ?? true) {
      return context.l10n.fullNameRequired;
    }
    if (value!.trim().length < 2) {
      return context.l10n.fullNameMinLength;
    }
    return null;
  }

  static String? validatePhone(String? value, BuildContext context) {
    if (value?.trim().isEmpty ?? true) {
      return context.l10n.phoneRequired;
    }
    if (value!.trim().length < 10) {
      return context.l10n.phoneMinLength;
    }
    return null;
  }

  static String? validateDOB(String? value, BuildContext context) {
    if (value?.trim().isEmpty ?? true) {
      return context.l10n.dobRequired;
    }
    return null;
  }

  static String? validateCountry(String? value, BuildContext context) {
    if (value?.trim().isEmpty ?? true) {
      return context.l10n.countryRequired;
    }
    return null;
  }
}
