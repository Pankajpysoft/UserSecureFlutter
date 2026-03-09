import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
import '../widgets/item_cards.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Saved Favorites'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Usernames'),
              Tab(text: 'Passwords'),
            ],
            indicatorColor: Color(0xFFADD8E6),
            labelColor: Color(0xFFADD8E6),
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: const TabBarView(
          children: [
            _FavoriteUsernamesTab(),
            _FavoritePasswordsTab(),
          ],
        ),
      ),
    );
  }
}

class _FavoriteUsernamesTab extends ConsumerWidget {
  const _FavoriteUsernamesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernames = ref.watch(savedUsernamesProvider);

    if (usernames.isEmpty) {
      return const Center(child: Text('No saved usernames yet.'));
    }

    return ListView.builder(
      itemCount: usernames.length,
      itemBuilder: (context, index) {
        final item = usernames[index];
        return UsernameCard(
          item: item,
          isSaved: true,
          onDelete: () => ref.read(savedUsernamesProvider.notifier).delete(item.id),
        );
      },
    );
  }
}

class _FavoritePasswordsTab extends ConsumerWidget {
  const _FavoritePasswordsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwords = ref.watch(savedPasswordsProvider);

    if (passwords.isEmpty) {
      return const Center(child: Text('No saved passwords yet.'));
    }

    return ListView.builder(
      itemCount: passwords.length,
      itemBuilder: (context, index) {
        final item = passwords[index];
        return PasswordCard(
          item: item,
          isSaved: true,
          onDelete: () => ref.read(savedPasswordsProvider.notifier).delete(item.id),
        );
      },
    );
  }
}
