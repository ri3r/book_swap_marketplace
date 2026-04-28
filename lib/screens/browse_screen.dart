import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/books_provider.dart';
import '../widgets/book_list_tile.dart';
import '../widgets/loading_widget.dart';
import '../widgets/app_error_widget.dart';
import '../widgets/empty_state_widget.dart';

class BrowseScreen extends ConsumerWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksState = ref.watch(booksProvider);
    final notifier = ref.read(booksProvider.notifier);

    return RefreshIndicator(
      onRefresh: () => notifier.loadInitial(),
      child: booksState.isLoading
          ? const LoadingWidget(message: 'Loading books...')
          : booksState.error != null
              ? AppErrorWidget(
                  message: booksState.error!,
                  onRetry: () => notifier.retry(),
                )
              : booksState.books.isEmpty
                  ? const EmptyStateWidget(
                      title: 'No Books Available',
                      message: 'Start by adding a listing or adjusting your filters',
                      icon: Icons.book,
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification) {
                          final metrics = notification.metrics;
                          if (metrics.extentAfter < 500) {
                            notifier.loadMore();
                          }
                        }
                        return true;
                      },
                      child: ListView.builder(
                        itemCount: booksState.books.length +
                            (booksState.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == booksState.books.length) {
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            );
                          }
                          final book = booksState.books[index];
                          return BookListTile(
                            book: book,
                            onTap: () => context.go('/book/${book.id}'),
                          );
                        },
                      ),
                    ),
    );
  }
}
