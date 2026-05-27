import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showLoginRequiredDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Not Now'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            context.go('/login');
          },
          child: const Text('Sign In'),
        ),
      ],
    ),
  );
}
