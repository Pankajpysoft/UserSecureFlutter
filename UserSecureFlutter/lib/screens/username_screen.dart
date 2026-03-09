import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item_model.dart';
import '../providers/favorites_provider.dart';
import '../services/username_generator.dart';
import '../widgets/item_cards.dart';
import 'package:uuid/uuid.dart';

class UsernameScreen extends ConsumerStatefulWidget {
  const UsernameScreen({super.key});

  @override
  ConsumerState<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends ConsumerState<UsernameScreen> {
  final _countController = TextEditingController(text: '5');
  String _selectedStyle = 'Cool';
  List<UsernameItem> _generatedUsernames = [];

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  void _generate() {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    int count = int.tryParse(_countController.text) ?? 5;
    count = count.clamp(1, 20);
    _countController.text = count.toString();

    final names = UsernameGenerator.generate(count, _selectedStyle);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    setState(() {
      _generatedUsernames = names.map((name) {
        return UsernameItem(
          id: const Uuid().v4(),
          timestamp: timestamp,
          username: name,
          style: _selectedStyle,
        );
      }).toList();
    });
  }

  Future<void> _saveUsername(UsernameItem item) async {
    final success = await ref.read(savedUsernamesProvider.notifier).save(item);
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Username saved!' : 'Username already saved.'),
        backgroundColor: success ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Usernames'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildControls(),
          if (_generatedUsernames.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'Tap Generate to create usernames!',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _generatedUsernames.length,
                itemBuilder: (context, index) {
                  final item = _generatedUsernames[index];
                  // Check if already saved for UI update
                  final isSaved = ref.watch(savedUsernamesProvider)
                      .any((saved) => saved.username == item.username);

                  return UsernameCard(
                    item: item,
                    isSaved: isSaved,
                    onSave: () => _saveUsername(item),
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
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _countController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Count (1-20)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  value: _selectedStyle,
                  decoration: const InputDecoration(
                    labelText: 'Style',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Cool', 'Funny', 'Professional']
                      .map((style) => DropdownMenuItem(
                            value: style,
                            child: Text(style),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedStyle = value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _generate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFADD8E6), // Light blue
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('GENERATE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
