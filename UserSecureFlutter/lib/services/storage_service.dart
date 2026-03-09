import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be overridden in main()');
});

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static const String _usernamesKey = 'saved_usernames';
  static const String _passwordsKey = 'saved_passwords';

  // --- Usernames ---

  List<UsernameItem> getUsernames() {
    final List<String> list = _prefs.getStringList(_usernamesKey) ?? [];
    final items = list.map((json) => SavedItem.fromJson(json) as UsernameItem).toList();
    // Sort by timestamp descending (newest first)
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items;
  }

  Future<void> saveUsername(UsernameItem item) async {
    final List<String> list = _prefs.getStringList(_usernamesKey) ?? [];
    list.add(item.toJson());
    await _prefs.setStringList(_usernamesKey, list);
  }

  Future<void> deleteUsername(String id) async {
    final List<String> list = _prefs.getStringList(_usernamesKey) ?? [];
    list.removeWhere((jsonStr) {
      final item = SavedItem.fromJson(jsonStr) as UsernameItem;
      return item.id == id;
    });
    await _prefs.setStringList(_usernamesKey, list);
  }

  bool usernameExists(String username) {
    final items = getUsernames();
    return items.any((item) => item.username == username);
  }

  // --- Passwords ---

  List<PasswordItem> getPasswords() {
    final List<String> list = _prefs.getStringList(_passwordsKey) ?? [];
    final items = list.map((json) => SavedItem.fromJson(json) as PasswordItem).toList();
    // Sort by timestamp descending (newest first)
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items;
  }

  Future<void> savePassword(PasswordItem item) async {
    final List<String> list = _prefs.getStringList(_passwordsKey) ?? [];
    list.add(item.toJson());
    await _prefs.setStringList(_passwordsKey, list);
  }

  Future<void> deletePassword(String id) async {
    final List<String> list = _prefs.getStringList(_passwordsKey) ?? [];
    list.removeWhere((jsonStr) {
      final item = SavedItem.fromJson(jsonStr) as PasswordItem;
      return item.id == id;
    });
    await _prefs.setStringList(_passwordsKey, list);
  }

  bool passwordExists(String password) {
    final items = getPasswords();
    return items.any((item) => item.password == password);
  }
}
