import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/books_provider.dart';
import '../widgets/book_list_tile.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/login_required_widget.dart';
import '../widgets/loading_widget.dart';

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final booksState = ref.watch(booksProvider);
    final theme = Theme.of(context);
    final previousLocation =
        GoRouterState.of(context).uri.queryParameters['from'];

    if (user == null) {
      return const LoginRequiredWidget(
        title: 'Sign in to view your listings',
        message: 'Your listings are saved to your account.',
        icon: Icons.library_books_outlined,
      );
    }

    if (booksState.isLoading) {
      return const LoadingWidget(message: 'Loading your listings...');
    }

    final listings = booksState.allBooks
        .where((book) => book.ownerId == user.uid)
        .toList()
      ..sort((a, b) => b.datePosted.compareTo(a.datePosted));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Back',
              onPressed: () => context.go(previousLocation ?? '/'),
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'My Listings',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${listings.length}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (listings.isEmpty)
          const EmptyStateWidget(
            title: 'No Listings Yet',
            message: 'Add a book to see it here.',
            icon: Icons.library_books_outlined,
          )
        else
          ...listings.map(
            (book) => BookListTile(
              book: book,
              onTap: () => context.push('/book/${book.id}'),
            ),
          ),
      ],
    );
  }
}
