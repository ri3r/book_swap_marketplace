import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final user = ref.watch(currentUserProvider);
    final previousLocation =
        GoRouterState.of(context).uri.queryParameters['from'];

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Back',
                  onPressed: () => context.go(previousLocation ?? '/'),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 4),
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // ── Account ─────────────────────────────────────────────
          if (user != null) ...[
            _SectionHeader('Account'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          (user.displayName?.isNotEmpty == true
                                  ? user.displayName![0]
                                  : user.email![0])
                              .toUpperCase(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (user.displayName?.isNotEmpty == true)
                              Text(
                                user.displayName!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            Text(
                              user.email ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Display Name'),
              onTap: () => _showEditNameDialog(context, ref, user.displayName),
            ),
            ListTile(
              leading: const Icon(Icons.lock_reset),
              title: const Text('Change Password'),
              subtitle: const Text('Sends a reset link to your email'),
              onTap: () => _sendPasswordReset(context, ref, user.email!),
            ),
            ListTile(
              leading: Icon(Icons.logout,
                  color: Theme.of(context).colorScheme.error),
              title: Text(
                'Sign Out',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () => _confirmSignOut(context, ref),
            ),
            const Divider(height: 32),
          ],

          // ── Theme ────────────────────────────────────────────────
          _SectionHeader('Theme'),
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

          // ── About ────────────────────────────────────────────────
          _SectionHeader('About'),
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
            onTap: () => _showInfo(
                context, 'Privacy Policy', 'Your privacy is important to us.'),
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

  Future<void> _showEditNameDialog(
      BuildContext context, WidgetRef ref, String? current) async {
    final controller = TextEditingController(text: current ?? '');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Display Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Name'),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (confirmed == true && controller.text.trim().isNotEmpty) {
      await ref
          .read(authServiceProvider)
          .currentUser
          ?.updateDisplayName(controller.text.trim());
      // Force provider refresh
      await ref.read(authServiceProvider).currentUser?.reload();
    }
    controller.dispose();
  }

  Future<void> _sendPasswordReset(
      BuildContext context, WidgetRef ref, String email) async {
    try {
      await ref.read(authServiceProvider).sendPasswordReset(email);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reset link sent to $email')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send reset email.')),
        );
      }
    }
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authServiceProvider).signOut();
      if (context.mounted) context.go('/login');
    }
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
