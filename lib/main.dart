import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/services/locale_setting.dart';
import 'core/utils/dio_client.dart';
import 'i18n/translations.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final sp = await SharedPreferences.getInstance();
  DioClient.init();
  
  // Initialize slang localization
  LocaleSettings.useDeviceLocale();
  
  runApp(
    ProviderScope(
      overrides: [
        localeControllerProvider.overrideWith((ref) => LocaleController(sp)),
      ],
      child: TranslationProvider(child: const NozieApp()),
    ),
  );
}
