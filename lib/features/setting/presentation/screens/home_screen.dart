import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '/core/services/theme_mode_notifier.dart';

class HomePage extends ConsumerWidget {

  final Locale locale;
  final void Function(Locale) onChangeLocale;

  const HomePage(this.locale, this.onChangeLocale, {super.key});

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
