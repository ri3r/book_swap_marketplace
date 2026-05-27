import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/books_provider.dart';
import '../models/book_listing.dart';
import '../widgets/book_list_tile.dart';
import '../widgets/loading_widget.dart';
import '../widgets/app_error_widget.dart';
import '../widgets/empty_state_widget.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(booksProvider.notifier).clearFilters();
    });
  }

  static const _heroImageUrl =
      'https://images.unsplash.com/photo-1551269901-5c5e14c25df7?auto=format&fit=crop&w=400&q=80';

  static final _genreCategories = [
    (
      category: BookCategory.fiction,
      backgroundColor: Color(0xFFE8F0FE),
      iconColor: Color(0xFF2563EB),
    ),
    (
      category: BookCategory.childrens,
      backgroundColor: Color(0xFFFED7E2),
      iconColor: Color(0xFFDB2777),
    ),
    (
      category: BookCategory.arts,
      backgroundColor: Color(0xFFE0E7FF),
      iconColor: Color(0xFF6366F1),
    ),
    (
      category: BookCategory.science,
      backgroundColor: Color(0xFFF0FDF4),
      iconColor: Color(0xFF16A34A),
    ),
    (
      category: BookCategory.technology,
      backgroundColor: Color(0xFFFCE7F3),
      iconColor: Color(0xFFBE185D),
    ),
    (
      category: BookCategory.history,
      backgroundColor: Color(0xFFFEF3C7),
      iconColor: Color(0xFFD97706),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final booksState = ref.watch(booksProvider);
    final notifier = ref.read(booksProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget heroCard() {
      // Find first swap book to display as featured
      final swapBooks = booksState.books
          .where((book) => book.type == ListingType.swap)
          .toList();
      final featuredBook = swapBooks.isNotEmpty ? swapBooks.first : null;

      if (featuredBook == null) {
        return const SizedBox.shrink();
      }

      return GestureDetector(
        onTap: () => context.go('/book/${featuredBook.id}'),
        child: Container(
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
                    featuredBook.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By ${featuredBook.author} - Available for swap.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withAlpha(
                        (0.74 * 255).round(),
                      ),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 18),
                  FilledButton.tonal(
                    onPressed: () => context.go('/book/${featuredBook.id}'),
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
        ),
      );
    }

    Widget categoryList() {
      return SizedBox(
        height: 110,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _genreCategories.length,
          separatorBuilder: (context, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final item = _genreCategories[index];
            final category = item.category;
            return GestureDetector(
              onTap: () {
                ref.read(booksProvider.notifier).setFilterCategory(category);
                context.go('/search');
              },
              child: Container(
                width: 96,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: item.backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: item.iconColor.withAlpha((0.16 * 255).round()),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        category.icon,
                        color: item.iconColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      category.displayName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
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

