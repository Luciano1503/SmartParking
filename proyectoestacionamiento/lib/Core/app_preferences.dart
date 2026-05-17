import 'package:flutter/material.dart';

class AppPreferences extends ChangeNotifier {
  AppPreferences._();

  static final AppPreferences instance = AppPreferences._();

  ThemeMode _themeMode = ThemeMode.dark;
  Locale _locale = const Locale('es');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void toggleLanguage() {
    _locale = _locale.languageCode == 'es'
        ? const Locale('en')
        : const Locale('es');
    notifyListeners();
  }
}

class AppPreferencesScope extends InheritedNotifier<AppPreferences> {
  AppPreferencesScope({super.key, required super.child})
    : super(notifier: AppPreferences.instance);

  static AppPreferences watch(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppPreferencesScope>();

    return scope?.notifier ?? AppPreferences.instance;
  }
}
