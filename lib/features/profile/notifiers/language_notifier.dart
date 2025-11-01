import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/locale_setting.dart';
import '../models/language_settings.dart';
import '../repository/settings_repository.dart';

class LanguageNotifier extends StateNotifier<AsyncValue<LanguageSettings>> {
  LanguageNotifier(this._ref, this._repository)
      : super(const AsyncValue.loading()) {
    _load();
  }

  final Ref _ref;
  final SettingsRepository _repository;

  Future<void> _load() async {
    try {
      final data = await _repository.fetchLanguageSettings();
      state = AsyncValue.data(data);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> select(String value) async {
    final updated = LanguageSettings(selected: value);
    state = AsyncValue.data(updated);
    try {
      await _repository.updateLanguage(updated);
      final locale = _parseLocale(value);
      await _ref.read(localeControllerProvider.notifier).setLocale(locale);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Locale _parseLocale(String value) {
    final parts = value.split('_');
    if (parts.length == 2) {
      return Locale(parts.first, parts.last.toUpperCase());
    }
    return Locale(value);
  }
}

final languageNotifierProvider =
    StateNotifierProvider<LanguageNotifier, AsyncValue<LanguageSettings>>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return LanguageNotifier(ref, repository);
});


