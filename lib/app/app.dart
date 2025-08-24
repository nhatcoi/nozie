import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_utils/country_utils.dart';

import '../l10n/app_localizations.dart';
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // i18n
      locale: locale,
      localizationsDelegates: [
        CountryLocalizations.delegate, // 👈 thêm dòng này
        ...AppLocalizations.localizationsDelegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      // theme
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      // routing
      initialRoute: AppRouters.welcome,
      onGenerateRoute: AppRouters.generateRoute,
    );
  }
}
