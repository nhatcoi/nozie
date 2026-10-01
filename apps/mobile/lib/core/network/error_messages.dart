import 'package:nozie_mobile/core/network/api_exception.dart';
import 'package:nozie_mobile/i18n/translations.g.dart';

/// Turns any error into text a person can act on, in the current language.
/// Screens must show this, never `error.toString()` (which leaks class names and server internals).
String errorMessage(Object error) {
  if (error is! ApiException) return t.errors.unknown;
  final e = t.errors;
  return switch (error.code) {
    'NETWORK' => e.network,
    'TIMEOUT' => e.timeout,
    'UNAUTHORIZED' || 'INVALID_TOKEN' || 'INVALID_GOOGLE_TOKEN' => e.unauthorized,
    'FORBIDDEN' || 'ACCOUNT_DISABLED' => e.forbidden,
    'NOT_FOUND' ||
    'MOVIE_NOT_FOUND' ||
    'USER_NOT_FOUND' ||
    'EPISODE_NOT_FOUND' ||
    'TRANSACTION_NOT_FOUND' ||
    'NOTIFICATION_NOT_FOUND' ||
    'REVIEW_NOT_FOUND' =>
      e.notFound,
    'VALIDATION_FAILED' || 'MALFORMED_REQUEST' => e.validation,
    'TOO_MANY_REQUESTS' => e.tooManyRequests,
    'INVALID_CREDENTIALS' => e.invalidCredentials,
    'EMAIL_TAKEN' => e.emailTaken,
    'USERNAME_TAKEN' => e.usernameTaken,
    'INVALID_OTP' => e.invalidOtp,
    'INVALID_RESET_TOKEN' => e.invalidResetToken,
    'PURCHASE_REQUIRED' => e.purchaseRequired,
    'ALREADY_PURCHASED' => e.alreadyPurchased,
    'PAYMENT_PROVIDER_ERROR' => e.paymentUnavailable,
    'FILE_TOO_LARGE' => e.fileTooLarge,
    'UNSUPPORTED_FILE_TYPE' => e.unsupportedFile,
    _ => (error.statusCode ?? 0) >= 500 ? e.server : e.unknown,
  };
}
