import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_stripe/flutter_stripe.dart';

import 'app/app.dart';
import 'core/config/env.dart';
import 'core/services/locale_setting.dart';
import 'core/network/api_client.dart';
import 'core/network/providers.dart';
import 'core/services/shared_prefs_provider.dart';
import 'core/session/session_state.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/data/api_auth_repository.dart';
import 'package:nozie_mobile/app/router/app_router.dart';
import 'i18n/translations.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final sp = await SharedPreferences.getInstance();

  // Session first: the router's guard reads it, so it must be resolved before the first frame.
  final session = SessionStore();
  final tokens = TokenStorage();
  await ApiAuthRepository(
    dio: buildApiClient(tokens: tokens, onSessionExpired: session.expire),
    tokens: tokens,
    session: session,
  ).restoreSession();
  AppRouter.configure(session);

  // Initialize Stripe
  // Publishable key only (safe to ship); comes from --dart-define, never from source control.
  if (Env.stripePublishableKey.isNotEmpty) {
    Stripe.publishableKey = Env.stripePublishableKey;
  }
  Stripe.merchantIdentifier = 'merchant.com.oggy.nozie';

  // Initialize slang locale BEFORE creating widget tree
  final savedLocaleCode = sp.getString('app_locale') ?? 'vi';
  final appLocale = AppLocale.values.firstWhere(
        (l) => l.languageCode == savedLocaleCode,
    orElse: () => AppLocale.vi,
  );
  LocaleSettings.setLocale(appLocale);

  runApp(
    ProviderScope(
      overrides: [
        localeControllerProvider.overrideWith((ref) => LocaleController(sp, ref)),
        sharedPreferencesProvider.overrideWithValue(sp),
        sessionStoreProvider.overrideWithValue(session),
        tokenStorageProvider.overrideWithValue(tokens),
      ],
      child: TranslationProvider(child: const NozieApp()),
    ),
  );
}
