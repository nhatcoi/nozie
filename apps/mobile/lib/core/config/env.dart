/// Build-time configuration. Pass with `--dart-define` (or `--dart-define-from-file=env/dev.json`).
///
/// ```
/// flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/api/v1
/// ```
class Env {
  Env._();

  /// Android emulator reaches the host machine at 10.0.2.2; iOS simulator/web use localhost.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );

  /// Scheme + host (+ port) of the API, for server-relative URLs such as avatars.
  static String get apiOrigin => Uri.parse(apiBaseUrl).origin;

  /// Stripe *publishable* key (safe to ship). The secret key only ever lives on the server.
  static const String stripePublishableKey =
      String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');

  /// Google OAuth **web** client id; required so Google returns an idToken our server can verify.
  static const String googleServerClientId =
      String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
}
