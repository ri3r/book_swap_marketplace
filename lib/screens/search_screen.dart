import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/books_provider.dart';
import '../providers/search_filters_provider.dart';
import '../models/book_listing.dart';
import '../utils/validators.dart';
import '../widgets/book_list_tile.dart';
import '../widgets/empty_state_widget.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _searchController;
  String? _searchError;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Re-apply saved search filters to booksProvider (Browse may have cleared them)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filters = ref.read(searchFiltersProvider);
      ref.read(booksProvider.notifier).setFilterCategory(filters.category);
      ref.read(booksProvider.notifier).setFilterType(filters.type);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    final error = Validators.validateSearch(query);
    setState(() => _searchError = error);
    if (error == null) {
      ref.read(booksProvider.notifier).setSearch(query);
    } else {
      ref.read(booksProvider.notifier).setSearch('');
    }
  }

  void _setCategory(BookCategory? category) {
    ref.read(searchFiltersProvider.notifier).setCategory(category);
    ref.read(booksProvider.notifier).setFilterCategory(category);
  }

  void _setType(ListingType? type) {
    ref.read(searchFiltersProvider.notifier).setType(type);
    ref.read(booksProvider.notifier).setFilterType(type);
  }

  @override
  Widget build(BuildContext context) {
    final booksState = ref.watch(booksProvider);
    final filters = ref.watch(searchFiltersProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Search your next Book',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search books by title or author',
                prefixIcon: const Icon(Icons.search),
                errorText: _searchError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _performSearch,
            ),
            const SizedBox(height: 24),
            Text(
              'Filter by Category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: filters.category == null,
                  onSelected: (_) => _setCategory(null),
                ),
                ...BookCategory.values.map((cat) => FilterChip(
                  label: Text(cat.displayName),
                  selected: filters.category == cat,
                  onSelected: (selected) =>
                      _setCategory(selected ? cat : null),
                )),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Filter by Type',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: filters.type == null,
                  onSelected: (_) => _setType(null),
                ),
                ...ListingType.values.map((type) => FilterChip(
                  label: Text(type.displayName),
                  selected: filters.type == type,
                  onSelected: (selected) =>
                      _setType(selected ? type : null),
                )),
              ],
            ),
            const SizedBox(height: 24),
            if (booksState.books.isNotEmpty) ...[
              Text(
                'Results (${booksState.books.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...booksState.books.map((book) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: BookListTile(
                  book: book,
                  onTap: () => context.go('/book/${book.id}'),
                ),
              )),
            ] else if (_searchController.text.isNotEmpty ||
                filters.category != null ||
                filters.type != null)
              const EmptyStateWidget(
                title: 'No Results',
                message: 'Try adjusting your search or filters',
              ),
          ],
        ),
      ),
    );
  }
}
