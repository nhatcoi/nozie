import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:nozie_mobile/app/app.dart';
import 'package:nozie_mobile/core/config/env.dart';
import 'package:nozie_mobile/core/services/locale_setting.dart';
import 'package:nozie_mobile/core/network/api_client.dart';
import 'package:nozie_mobile/core/network/providers.dart';
import 'package:nozie_mobile/core/services/shared_prefs_provider.dart';
import 'package:nozie_mobile/core/session/session_state.dart';
import 'package:nozie_mobile/core/storage/token_storage.dart';
import 'package:nozie_mobile/features/auth/api_auth_repository.dart';
import 'package:nozie_mobile/app/app_router.dart';
import 'package:nozie_mobile/i18n/translations.g.dart';

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
