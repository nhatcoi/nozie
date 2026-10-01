import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nozie_mobile/features/setting/language_notifier.dart';
import 'package:nozie_mobile/features/setting/notification_notifier.dart';
import 'package:nozie_mobile/features/setting/payment_notifier.dart';
import 'package:nozie_mobile/features/setting/preferences_notifier.dart';
import 'package:nozie_mobile/features/profile/profile_notifier.dart';
import 'package:nozie_mobile/features/setting/security_notifier.dart';
import 'package:nozie_mobile/features/setting/settings_repository.dart';

/// Service to handle user logout by clearing all user data
class LogoutService {
  static Future<void> logout(WidgetRef ref) async {
    try {
      // Clear all user data from SharedPreferences
      final repository = ref.read(settingsRepositoryProvider);
      await repository.clearUserData();

      // Invalidate all Riverpod providers to reset their state
      ref.invalidate(profileNotifierProvider);
      ref.invalidate(notificationNotifierProvider);
      ref.invalidate(preferencesNotifierProvider);
      ref.invalidate(securityNotifierProvider);
      ref.invalidate(languageNotifierProvider);
      ref.invalidate(paymentNotifierProvider);
      
      debugPrint('[LogoutService] User data cleared and providers invalidated');
    } catch (error) {
      debugPrint('[LogoutService] Error during logout: $error');
    }
  }
}
