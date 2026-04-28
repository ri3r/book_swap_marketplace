import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/books_provider.dart';
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
  BookCategory? _selectedCategory;
  ListingType? _selectedType;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    final booksState = ref.watch(booksProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  selected: _selectedCategory == null,
                  onSelected: (selected) {
                    setState(() => _selectedCategory = null);
                    ref.read(booksProvider.notifier).setFilterCategory(null);
                  },
                ),
                ...BookCategory.values.map((cat) => FilterChip(
                  label: Text(cat.displayName),
                  selected: _selectedCategory == cat,
                  onSelected: (selected) {
                    setState(
                        () => _selectedCategory = selected ? cat : null);
                    ref
                        .read(booksProvider.notifier)
                        .setFilterCategory(selected ? cat : null);
                  },
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
                  selected: _selectedType == null,
                  onSelected: (selected) {
                    setState(() => _selectedType = null);
                    ref.read(booksProvider.notifier).setFilterType(null);
                  },
                ),
                ...ListingType.values.map((type) => FilterChip(
                  label: Text(type.displayName),
                  selected: _selectedType == type,
                  onSelected: (selected) {
                    setState(() => _selectedType = selected ? type : null);
                    ref
                        .read(booksProvider.notifier)
                        .setFilterType(selected ? type : null);
                  },
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
            ] else if (_searchController.text.isNotEmpty)
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
