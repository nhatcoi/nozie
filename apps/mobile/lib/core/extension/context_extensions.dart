import 'package:flutter/widgets.dart';
import 'package:nozie_mobile/i18n/translations.g.dart';

extension LocalizationExtension on BuildContext {
  /// Hierarchical i18n access method
  Translations get i18n => t;
}