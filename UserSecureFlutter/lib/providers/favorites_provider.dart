import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item_model.dart';
import '../services/storage_service.dart';

// --- Usernames State ---

final savedUsernamesProvider = StateNotifierProvider<SavedUsernamesNotifier, List<UsernameItem>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return SavedUsernamesNotifier(storage);
});

class SavedUsernamesNotifier extends StateNotifier<List<UsernameItem>> {
  final StorageService _storage;

  SavedUsernamesNotifier(this._storage) : super(_storage.getUsernames());

  Future<bool> save(UsernameItem item) async {
    if (_storage.usernameExists(item.username)) {
      return false; // Already exists
    }
    await _storage.saveUsername(item);
    state = _storage.getUsernames(); // Refresh state
    return true;
  }

  Future<void> delete(String id) async {
    await _storage.deleteUsername(id);
    state = _storage.getUsernames(); // Refresh state
  }

  void refresh() {
    state = _storage.getUsernames();
  }
}

// --- Passwords State ---

final savedPasswordsProvider = StateNotifierProvider<SavedPasswordsNotifier, List<PasswordItem>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return SavedPasswordsNotifier(storage);
});

class SavedPasswordsNotifier extends StateNotifier<List<PasswordItem>> {
  final StorageService _storage;

  SavedPasswordsNotifier(this._storage) : super(_storage.getPasswords());

  Future<bool> save(PasswordItem item) async {
    if (_storage.passwordExists(item.password)) {
      return false; // Already exists
    }
    await _storage.savePassword(item);
    state = _storage.getPasswords(); // Refresh state
    return true;
  }

  Future<void> delete(String id) async {
    await _storage.deletePassword(id);
    state = _storage.getPasswords(); // Refresh state
  }

  void refresh() {
    state = _storage.getPasswords();
  }
}
