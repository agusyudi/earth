import 'dart:convert';
import '../../main.dart';

Future<bool> isLoggedIn() async {
  final session = await getDataSession("iduser");
  return session != null;
}

/// Ambil data dari session (shared preferences)
Future<dynamic> getDataSession(String key) async {
  var data = sharedPref.get(key);
  if (data == null) return null;
  return jsonDecode(data);
}

/// Simpan data ke session (shared preferences)
Future<void> setDataSession(String key, dynamic value) async {
  if (value == null || value.toString().trim() == "") return;
  await sharedPref.setString(key, jsonEncode(value), notify: true);
}

/// Hapus 1 data session
Future<void> removeDataSession(String key) async {
  await sharedPref.remove(key);
}

/// Hapus semua data session
Future<void> eraseDataSession() async {
  await sharedPref.clear();
}

/// Ambil tema dari session (return bool as dynamic)
Future<bool?> getTema() async {
  return sharedPrefLifeTime.getBool("isDarkMode") ?? true;
}

/// Simpan data "lifetime" ke shared_preferences (sebenarnya tidak terenkripsi & tetap bisa dihapus user)
Future<void> setLifetimeStorageData(String key, dynamic value) async {
  await sharedPrefLifeTime.setString(key, jsonEncode(value), notify: true);
}

/// Ambil data "lifetime"
Future<String?> getLifetimeStorageData(String key) async {
  return sharedPrefLifeTime.getString(key);
}
