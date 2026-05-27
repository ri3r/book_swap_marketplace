import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginRequiredWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const LoginRequiredWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.lock_outline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.go('/login'),
                child: const Text('Sign In'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go('/register'),
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
