import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/clipboard_helper.dart';
import '../services/password_generator.dart';
import 'strength_meter.dart';

class UsernameCard extends StatelessWidget {
  final UsernameItem item;
  final VoidCallback? onSave;
  final VoidCallback? onDelete;
  final bool isSaved;

  const UsernameCard({
    super.key,
    required this.item,
    this.onSave,
    this.onDelete,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.username,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Style: ${item.style}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.blueGrey),
              onPressed: () => ClipboardHelper.copyToClipboard(context, item.username),
              tooltip: 'Copy',
            ),
            if (onSave != null && !isSaved)
              IconButton(
                icon: const Icon(Icons.save, color: Colors.blue),
                onPressed: onSave,
                tooltip: 'Save',
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
                tooltip: 'Delete',
              ),
          ],
        ),
      ),
    );
  }
}

class PasswordCard extends StatelessWidget {
  final PasswordItem item;
  final VoidCallback? onSave;
  final VoidCallback? onDelete;
  final bool isSaved;

  const PasswordCard({
    super.key,
    required this.item,
    this.onSave,
    this.onDelete,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.password,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StrengthMeter(
                    strength: item.strength,
                    score: PasswordGenerator.getStrengthScore(item.password),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.blueGrey),
              onPressed: () => ClipboardHelper.copyToClipboard(context, item.password),
              tooltip: 'Copy',
            ),
            if (onSave != null && !isSaved)
              IconButton(
                icon: const Icon(Icons.save, color: Colors.blue),
                onPressed: onSave,
                tooltip: 'Save',
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
                tooltip: 'Delete',
              ),
          ],
        ),
      ),
    );
  }
}
