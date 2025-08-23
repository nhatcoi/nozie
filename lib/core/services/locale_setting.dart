// lib/core/services/locale_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeControllerProvider =
StateNotifierProvider<LocaleController, Locale>((ref) {
  throw UnimplementedError('Must be overridden with SharedPreferences');
});

class LocaleController extends StateNotifier<Locale> {
  LocaleController(this._prefs, {String defaultCode = 'en'})
      : super(Locale(_prefs.getString('app_locale') ?? defaultCode));

  final SharedPreferences _prefs;

  Future<void> setLocale(Locale l) async {
    state = l;
    await _prefs.setString('app_locale', l.languageCode);
  }
}
