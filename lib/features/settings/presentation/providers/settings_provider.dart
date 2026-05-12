import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final Locale? locale;
  final ThemeMode themeMode;

  const SettingsState({this.locale, this.themeMode = ThemeMode.system});

  SettingsState copyWith({Locale? Function()? locale, ThemeMode? themeMode}) {
    return SettingsState(
      locale: locale != null ? locale() : this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('pref_locale');
    final themeIndex = prefs.getInt('pref_theme') ?? 0;
    state = SettingsState(
      locale: localeCode != null ? Locale(localeCode) : null,
      themeMode: ThemeMode.values[themeIndex],
    );
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale != null) {
      await prefs.setString('pref_locale', locale.languageCode);
    } else {
      await prefs.remove('pref_locale');
    }
    state = state.copyWith(locale: () => locale);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pref_theme', mode.index);
    state = state.copyWith(themeMode: mode);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
