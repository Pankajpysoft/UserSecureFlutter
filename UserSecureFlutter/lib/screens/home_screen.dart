import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
import '../widgets/item_cards.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('UserSecure', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Recent Usernames'),
              Tab(text: 'Recent Passwords'),
            ],
            indicatorColor: Color(0xFFADD8E6),
            labelColor: Color(0xFFADD8E6),
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: const TabBarView(
          children: [
            _RecentUsernamesTab(),
            _RecentPasswordsTab(),
          ],
        ),
      ),
    );
  }
}

class _RecentUsernamesTab extends ConsumerWidget {
  const _RecentUsernamesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernames = ref.watch(savedUsernamesProvider);
    final recent = usernames.take(5).toList();

    if (recent.isEmpty) {
      return const Center(child: Text('No recent usernames.\nGo to Username tab to generate!', textAlign: TextAlign.center));
    }

    return ListView.builder(
      itemCount: recent.length,
      itemBuilder: (context, index) {
        return UsernameCard(item: recent[index], isSaved: true);
      },
    );
  }
}

class _RecentPasswordsTab extends ConsumerWidget {
  const _RecentPasswordsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwords = ref.watch(savedPasswordsProvider);
    final recent = passwords.take(5).toList();

    if (recent.isEmpty) {
      return const Center(child: Text('No recent passwords.\nGo to Password tab to generate!', textAlign: TextAlign.center));
    }

    return ListView.builder(
      itemCount: recent.length,
      itemBuilder: (context, index) {
        return PasswordCard(item: recent[index], isSaved: true);
      },
    );
  }
}
