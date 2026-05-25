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

  static const _heroImageUrl =
      'https://images.unsplash.com/photo-1551269901-5c5e14c25df7?auto=format&fit=crop&w=400&q=80';

  static final _categories = [
    _BrowseCategory(
      title: 'Trending',
      icon: Icons.local_fire_department,
      backgroundColor: Color(0xFFFFF1E5),
      iconColor: Color(0xFFEA580C),
    ),
    _BrowseCategory(
      title: 'Fiction',
      icon: Icons.menu_book,
      backgroundColor: Color(0xFFE8F0FE),
      iconColor: Color(0xFF2563EB),
    ),
    _BrowseCategory(
      title: 'Romance',
      icon: Icons.favorite,
      backgroundColor: Color(0xFFFED7E2),
      iconColor: Color(0xFFDB2777),
    ),
    _BrowseCategory(
      title: 'Sci-Fi',
      icon: Icons.star,
      backgroundColor: Color(0xFFEDE9FE),
      iconColor: Color(0xFF7C3AED),
    ),
    _BrowseCategory(
      title: 'Explore',
      icon: Icons.explore,
      backgroundColor: Color(0xFFE6F6F1),
      iconColor: Color(0xFF0F766E),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksState = ref.watch(booksProvider);
    final notifier = ref.read(booksProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget heroCard() {
      return Container(
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.light
              ? const Color(0xFFE1F0F8)
              : colorScheme.primary.withAlpha((0.16 * 255).round()),
          borderRadius: BorderRadius.circular(32),
        ),
        padding: const EdgeInsets.all(24),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withAlpha(
                      (0.08 * 255).round(),
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 16, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Staff Pick',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Harry Potter\nCollection',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Available for swap.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withAlpha(
                      (0.74 * 255).round(),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.tonal(
                  onPressed: () => context.go('/search'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    backgroundColor: theme.brightness == Brightness.light
                        ? Colors.white
                        : colorScheme.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('View Details'),
                      const SizedBox(width: 10),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.light
                              ? const Color(0xFFF1F5F9)
                              : Colors.white.withAlpha(220),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          size: 16,
                          color: theme.brightness == Brightness.light
                              ? colorScheme.onSurface
                              : colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: -8,
              bottom: -12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  width: 140,
                  height: 170,
                  child: Image.network(_heroImageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget categoryList() {
      return SizedBox(
        height: 110,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          separatorBuilder: (context, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final category = _categories[index];
            return Container(
              width: 96,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: category.backgroundColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: category.iconColor.withAlpha((0.16 * 255).round()),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      category.icon,
                      color: category.iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    category.title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    Widget bookHeader() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Near You',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/search'),
              child: const Text('See All'),
            ),
          ],
        ),
      );
    }

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
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: heroCard(),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Select genre',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        categoryList(),
                        const SizedBox(height: 24),
                        bookHeader(),
                      ]),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final book = booksState.books[index];
                      return BookListTile(
                        book: book,
                        onTap: () => context.go('/book/${book.id}'),
                      );
                    }, childCount: booksState.books.length),
                  ),
                  if (booksState.isLoadingMore)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _BrowseCategory {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _BrowseCategory({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });
}
