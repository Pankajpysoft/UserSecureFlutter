import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item_model.dart';
import '../providers/favorites_provider.dart';
import '../services/password_generator.dart';
import '../widgets/item_cards.dart';
import 'package:uuid/uuid.dart';

class PasswordScreen extends ConsumerStatefulWidget {
  const PasswordScreen({super.key});

  @override
  ConsumerState<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ConsumerState<PasswordScreen> {
  double _length = 12;
  bool _useUppercase = true;
  bool _useLowercase = true;
  bool _useNumbers = true;
  bool _useSymbols = true;
  
  List<PasswordItem> _generatedPasswords = [];

  void _generate() {
    if (!_useUppercase && !_useLowercase && !_useNumbers && !_useSymbols) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one character type')),
      );
      return;
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newPasswords = <PasswordItem>[];

    for (int i = 0; i < 5; i++) {
      final pwd = PasswordGenerator.generate(
        length: _length.toInt(),
        useUppercase: _useUppercase,
        useLowercase: _useLowercase,
        useNumbers: _useNumbers,
        useSymbols: _useSymbols,
      );
      
      newPasswords.add(PasswordItem(
        id: const Uuid().v4(),
        timestamp: timestamp,
        password: pwd,
        length: _length.toInt(),
        strength: PasswordGenerator.calculateStrength(pwd),
      ));
    }

    setState(() {
      _generatedPasswords = newPasswords;
    });
  }

  Future<void> _savePassword(PasswordItem item) async {
    final success = await ref.read(savedPasswordsProvider.notifier).save(item);
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Password saved!' : 'Password already saved.'),
        backgroundColor: success ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Passwords'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildControls(),
          if (_generatedPasswords.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'Tap Generate to create passwords!',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _generatedPasswords.length,
                itemBuilder: (context, index) {
                  final item = _generatedPasswords[index];
                  final isSaved = ref.watch(savedPasswordsProvider)
                      .any((saved) => saved.password == item.password);

                  return PasswordCard(
                    item: item,
                    isSaved: isSaved,
                    onSave: () => _savePassword(item),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Length: ${_length.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Slider(
                  value: _length,
                  min: 4,
                  max: 32,
                  divisions: 28,
                  activeColor: const Color(0xFFADD8E6),
                  label: _length.toInt().toString(),
                  onChanged: (val) => setState(() => _length = val),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text('A-Z'),
                  value: _useUppercase,
                  onChanged: (val) => setState(() => _useUppercase = val ?? true),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('a-z'),
                  value: _useLowercase,
                  onChanged: (val) => setState(() => _useLowercase = val ?? true),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text('0-9'),
                  value: _useNumbers,
                  onChanged: (val) => setState(() => _useNumbers = val ?? true),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('!@#'),
                  value: _useSymbols,
                  onChanged: (val) => setState(() => _useSymbols = val ?? true),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _generate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFADD8E6),
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('GENERATE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
