import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../features/auth/welcome/welcome_screen.dart';
import '../i18n/translations.g.dart';
import '../core/services/locale_setting.dart';
import '../core/services/theme_mode_notifier.dart';
import '../core/theme/app_theme.dart';
import '../routes/app_router.dart';



class NozieApp extends ConsumerWidget {
  const NozieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeControllerProvider); // locale từ Riverpod

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      // i18n
      locale: locale,
      supportedLocales: AppLocale.values.map((locale) => locale.flutterLocale),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // theme
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      // routing with go_router
      routerConfig: AppRouter.router,
    );
  }
}
