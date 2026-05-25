import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Theme',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text('Light Mode'),
            leading: const Icon(Icons.light_mode),
            onTap: () => themeNotifier.setThemeMode(ThemeMode.light),
            trailing: currentTheme == ThemeMode.light
                ? Icon(Icons.check,
                    color: Theme.of(context).colorScheme.primary)
                : null,
          ),
          ListTile(
            title: const Text('Dark Mode'),
            leading: const Icon(Icons.dark_mode),
            onTap: () => themeNotifier.setThemeMode(ThemeMode.dark),
            trailing: currentTheme == ThemeMode.dark
                ? Icon(Icons.check,
                    color: Theme.of(context).colorScheme.primary)
                : null,
          ),
          ListTile(
            title: const Text('System Default'),
            leading: const Icon(Icons.brightness_auto),
            onTap: () => themeNotifier.setThemeMode(ThemeMode.system),
            trailing: currentTheme == ThemeMode.system
                ? Icon(Icons.check,
                    color: Theme.of(context).colorScheme.primary)
                : null,
          ),
          const Divider(height: 32),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'About',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text('About BookSwap'),
            subtitle: const Text('Team, features & technology'),
            leading: const Icon(Icons.info_outline),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/about'),
          ),
          ListTile(
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
            leading: const Icon(Icons.tag),
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            leading: const Icon(Icons.privacy_tip),
            onTap: () => _showInfo(context, 'Privacy Policy',
                'Your privacy is important to us.'),
          ),
          ListTile(
            title: const Text('Terms of Service'),
            leading: const Icon(Icons.description),
            onTap: () => _showInfo(context, 'Terms of Service',
                'Please read our terms and conditions.'),
          ),
        ],
      ),
    );
  }

  void _showInfo(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
