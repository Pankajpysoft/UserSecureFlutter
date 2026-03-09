import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item_model.dart';
import '../providers/favorites_provider.dart';
import '../services/clipboard_helper.dart';
import '../services/password_generator.dart';
import '../services/username_generator.dart';
import 'package:uuid/uuid.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _inputController = TextEditingController();
  bool _isUsername = true;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _autoGenerate() {
    FocusScope.of(context).unfocus();
    String generated;
    if (_isUsername) {
      generated = UsernameGenerator.generateOne('Cool');
    } else {
      generated = PasswordGenerator.generate(
        length: 12,
        useUppercase: true,
        useLowercase: true,
        useNumbers: true,
        useSymbols: false,
      );
    }
    
    setState(() {
      _inputController.text = generated;
    });
  }

  void _copy() {
    FocusScope.of(context).unfocus();
    final text = _inputController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing to copy!')),
      );
      return;
    }
    ClipboardHelper.copyToClipboard(context, text);
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final text = _inputController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter or generate an item first')),
      );
      return;
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    bool success;

    if (_isUsername) {
      final item = UsernameItem(
        id: const Uuid().v4(),
        timestamp: timestamp,
        username: text,
        style: 'Manual',
      );
      success = await ref.read(savedUsernamesProvider.notifier).save(item);
    } else {
      final item = PasswordItem(
        id: const Uuid().v4(),
        timestamp: timestamp,
        password: text,
        length: text.length,
        strength: PasswordGenerator.calculateStrength(text),
      );
      success = await ref.read(savedPasswordsProvider.notifier).save(item);
    }

    if (!mounted) return;

    if (success) {
      _inputController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item saved!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item already saved.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Existing Item'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'What type of item would you like to add?',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Username'),
                              value: true,
                              groupValue: _isUsername,
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _isUsername = val;
                                    _inputController.clear();
                                  });
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                              activeColor: const Color(0xFFADD8E6),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Password'),
                              value: false,
                              groupValue: _isUsername,
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _isUsername = val;
                                    _inputController.clear();
                                  });
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                              activeColor: const Color(0xFFADD8E6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  labelText: _isUsername ? 'Enter username...' : 'Enter password...',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onIcon: const Icon(Icons.flash_on),
                  icon: const Icon(Icons.flash_on),
                  label: const Text('Auto-Generate Instead'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFADD8E6),
                  ),
                  onPressed: _autoGenerate,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onIcon: const Icon(Icons.copy),
                      icon: const Icon(Icons.copy),
                      label: const Text('COPY', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: Colors.blueGrey,
                        side: const BorderSide(color: Colors.blueGrey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _copy,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onIcon: const Icon(Icons.save),
                      icon: const Icon(Icons.save),
                      label: const Text('SAVE', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFFADD8E6),
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _save,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
