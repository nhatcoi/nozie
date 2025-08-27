import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../features/auth/welcome/welcome_screen.dart';
import '../i18n/translations.g.dart';
import '../core/services/locale_setting.dart';
import '../core/services/theme_mode_notifier.dart';
import '../core/theme/app_theme.dart';
import '../routes/app_routers.dart';



class NozieApp extends ConsumerWidget {
  const NozieApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeControllerProvider); // locale từ Riverpod

    // Update slang locale when locale changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appLocale = AppLocale.values.firstWhere(
        (l) => l.languageCode == locale.languageCode,
        orElse: () => AppLocale.en,
      );
      LocaleSettings.setLocale(appLocale);
    });

    return MaterialApp(
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

      // routing
      initialRoute: AppRouters.welcome,
      onGenerateRoute: AppRouters.generateRoute,
    
      home: WelcomeScreen(),

    );
  }
}
