import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book_listing.dart';
import '../services/book_service.dart';
import '../services/firestore_book_service.dart';

const int _pageSize = 10;

class BooksState {
  final List<BookListing> books;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasMore;
  final String searchQuery;
  final BookCategory? filterCategory;
  final ListingType? filterType;

  const BooksState({
    this.books = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasMore = true,
    this.searchQuery = '',
    this.filterCategory,
    this.filterType,
  });

  BooksState copyWith({
    List<BookListing>? books,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasMore,
    String? searchQuery,
    BookCategory? filterCategory,
    ListingType? filterType,
  }) => BooksState(
    books: books ?? this.books,
    isLoading: isLoading ?? this.isLoading,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    error: error ?? this.error,
    hasMore: hasMore ?? this.hasMore,
    searchQuery: searchQuery ?? this.searchQuery,
    filterCategory: filterCategory ?? this.filterCategory,
    filterType: filterType ?? this.filterType,
  );
}

class BooksNotifier extends StateNotifier<BooksState> {
  final BookService _service;
  List<BookListing> _allBooks = [];
  List<BookListing> _filteredBooks = [];

  BooksNotifier(this._service) : super(const BooksState()) {
    loadInitial();
  }

  List<BookListing> _applyFilters(List<BookListing> books) {
    var filtered = books;

    if (state.searchQuery.isNotEmpty) {
      filtered = _service.searchBooks(filtered, state.searchQuery);
    }

    if (state.filterCategory != null) {
      filtered = _service.filterByCategory(filtered, state.filterCategory!);
    }

    if (state.filterType != null) {
      filtered = _service.filterByType(filtered, state.filterType!);
    }

    return filtered;
  }

  Future<void> loadInitial() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      _allBooks = await _service.loadAllBooks();
      _filteredBooks = _applyFilters(_allBooks);
      final page = _filteredBooks.take(_pageSize).toList();
      state = state.copyWith(
        books: page,
        isLoading: false,
        hasMore: _filteredBooks.length > _pageSize,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    await Future.delayed(const Duration(milliseconds: 200));
    final nextPage = _filteredBooks.skip(state.books.length).take(_pageSize);
    state = state.copyWith(
      books: [...state.books, ...nextPage],
      isLoadingMore: false,
      hasMore: state.books.length + nextPage.length < _filteredBooks.length,
    );
  }

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
    _filteredBooks = _applyFilters(_allBooks);
    final page = _filteredBooks.take(_pageSize).toList();
    state = state.copyWith(
      books: page,
      hasMore: _filteredBooks.length > _pageSize,
    );
  }

  void setFilterCategory(BookCategory? category) {
    state = BooksState(
      books: state.books,
      isLoading: state.isLoading,
      isLoadingMore: state.isLoadingMore,
      error: state.error,
      hasMore: state.hasMore,
      searchQuery: state.searchQuery,
      filterCategory: category,
      filterType: state.filterType,
    );
    _filteredBooks = _applyFilters(_allBooks);
    final page = _filteredBooks.take(_pageSize).toList();
    state = state.copyWith(
      books: page,
      hasMore: _filteredBooks.length > _pageSize,
    );
  }

  void setFilterType(ListingType? type) {
    state = BooksState(
      books: state.books,
      isLoading: state.isLoading,
      isLoadingMore: state.isLoadingMore,
      error: state.error,
      hasMore: state.hasMore,
      searchQuery: state.searchQuery,
      filterCategory: state.filterCategory,
      filterType: type,
    );
    _filteredBooks = _applyFilters(_allBooks);
    final page = _filteredBooks.take(_pageSize).toList();
    state = state.copyWith(
      books: page,
      hasMore: _filteredBooks.length > _pageSize,
    );
  }

  void clearFilters() {
    state = BooksState(
      books: state.books,
      isLoading: state.isLoading,
      isLoadingMore: state.isLoadingMore,
      error: state.error,
      hasMore: state.hasMore,
      searchQuery: '',
      filterCategory: null,
      filterType: null,
    );
    _filteredBooks = _applyFilters(_allBooks);
    final page = _filteredBooks.take(_pageSize).toList();
    state = state.copyWith(
      books: page,
      hasMore: _filteredBooks.length > _pageSize,
    );
  }

  Future<void> addListing(BookListing listing) async {
    try {
      // Save to Firestore if available
      if (_service is FirestoreBookService) {
        await (_service as FirestoreBookService).saveBook(listing);
      }
      final updated = [listing, ..._allBooks];
      _allBooks = updated;
      _filteredBooks = _applyFilters(_allBooks);
      final page = _filteredBooks.take(_pageSize).toList();
      state = state.copyWith(
        books: page,
        hasMore: _filteredBooks.length > _pageSize,
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to add listing: $e');
    }
  }

  Future<void> retry() => loadInitial();
}

final bookServiceProvider = Provider<BookService>(
  (ref) => FirestoreBookService(),
);

final booksProvider = StateNotifierProvider<BooksNotifier, BooksState>(
  (ref) => BooksNotifier(ref.watch(bookServiceProvider)),
);
