import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/theme_mode_notifier.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sp = await SharedPreferences.getInstance();
  final code = sp.getString('app_locale') ?? 'en';
  runApp(ProviderScope(child: MyApp(initialLocale: Locale(code))));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key, required this.initialLocale});
  final Locale initialLocale;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late Locale _locale = widget.initialLocale;

  Future<void> _setLocale(Locale l) async {
    setState(() => _locale = l);
    final sp = await SharedPreferences.getInstance();
    await sp.setString('app_locale', l.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider); // Riverpod here

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // i18n
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (device, supported) {
        if (device == null) return _locale;
        for (final l in supported) {
          if (l.languageCode == device.languageCode) return l;
        }
        return _locale;
      },

      // theme
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      home: HomePage(
        locale: _locale,
        onChangeLocale: _setLocale,
      ),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({
    super.key,
    required this.locale,
    required this.onChangeLocale,
  });

  final Locale locale;
  final void Function(Locale) onChangeLocale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.appTitle)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${t.login} • ${t.password}'),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'vi', label: Text('Tiếng Việt')),
                ButtonSegment(value: 'en', label: Text('English')),
              ],
              selected: {locale.languageCode},
              onSelectionChanged: (s) => onChangeLocale(Locale(s.first)),
            ),

            const SizedBox(height: 24),

            // ---- Switch theme: System / Light / Dark ----
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.phone_iphone), label: Text('System')),
                ButtonSegment(value: ThemeMode.light,  icon: Icon(Icons.light_mode),  label: Text('Light')),
                ButtonSegment(value: ThemeMode.dark,   icon: Icon(Icons.dark_mode),   label: Text('Dark')),
              ],
              selected: {themeMode},
              onSelectionChanged: (s) => ref.read(themeModeProvider.notifier).set(s.first),
            ),
            
            ElevatedButton(onPressed: () {}, child: Text("data"))
          ],
        ),
      ),
    );
  }
}
