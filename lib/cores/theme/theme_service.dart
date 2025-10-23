import 'package:flutter/material.dart';

import '../../services/session_service.dart';

class ThemeService extends ChangeNotifier {
  static const String _storageKey = 'isDarkMode';

  bool _isDarkMode = false;

  /// Getter untuk akses state internal
  bool get isDarkMode => _isDarkMode;

  /// Getter untuk Flutter ThemeMode
  ThemeMode getThemeMode() => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Muat tema dari SharedPreferences via getTema()
  Future<void> loadThemeFromStorage() async {
    _isDarkMode = await getTema() ?? false;
    notifyListeners();
  }

  /// Toggle tema dan simpan menggunakan setDataSession()
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await setLifetimeStorageData(_storageKey, _isDarkMode);
    notifyListeners();
  }
}
