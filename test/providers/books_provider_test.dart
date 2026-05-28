import 'package:boook_marketplace/models/book_listing.dart';
import 'package:boook_marketplace/providers/books_provider.dart';
import 'package:boook_marketplace/services/book_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeBookService extends BookService {
  final List<BookListing> books;

  FakeBookService(this.books);

  @override
  Future<List<BookListing>> loadAllBooks() async => books;
}

class FailingBookService extends BookService {
  @override
  Future<List<BookListing>> loadAllBooks() async {
    throw Exception('network unavailable');
  }
}

BookListing makeBook(
  int index, {
  BookCategory category = BookCategory.fiction,
  ListingType type = ListingType.sale,
}) {
  return BookListing(
    id: '$index',
    title: 'Book $index',
    author: 'Author $index',
    price: index.toDouble(),
    condition: BookCondition.good,
    type: type,
    category: category,
    description: 'Description for generated book $index.',
    sellerName: 'Seller $index',
    sellerContact: 'seller$index@example.com',
    location: 'City $index',
    datePosted: DateTime(2026, 5, index),
  );
}

void main() {
  group('BooksNotifier', () {
    final books = [
      BookListing(
        id: '1',
        title: 'Flutter Basics',
        author: 'Dana Dev',
        price: 10,
        condition: BookCondition.good,
        type: ListingType.sale,
        category: BookCategory.technology,
        description: 'A beginner friendly Flutter guide.',
        sellerName: 'Dana',
        sellerContact: 'dana@example.com',
        location: 'Berlin',
        datePosted: DateTime(2026, 5, 1),
      ),
      BookListing(
        id: '2',
        title: 'World History',
        author: 'Chris Stone',
        price: 0,
        condition: BookCondition.fair,
        type: ListingType.swap,
        category: BookCategory.history,
        description: 'A broad overview of modern history.',
        sellerName: 'Chris',
        sellerContact: 'chris@example.com',
        location: 'Hamburg',
        datePosted: DateTime(2026, 5, 2),
      ),
    ];

    test('loads initial books from the service', () async {
      final notifier = BooksNotifier(FakeBookService(books));
      await notifier.loadInitial();

      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.error, isNull);
      expect(notifier.state.books, books);
      expect(notifier.state.allBooks, books);
    });

    test('setSearch filters the loaded books', () async {
      final notifier = BooksNotifier(FakeBookService(books));
      await notifier.loadInitial();

      notifier.setSearch('history');

      expect(notifier.state.searchQuery, 'history');
      expect(notifier.state.books, [books[1]]);
    });

    test('setFilterCategory filters by category', () async {
      final notifier = BooksNotifier(FakeBookService(books));
      await notifier.loadInitial();

      notifier.setFilterCategory(BookCategory.technology);

      expect(notifier.state.filterCategory, BookCategory.technology);
      expect(notifier.state.books, [books[0]]);
    });

    test('setFilterType filters by listing type', () async {
      final notifier = BooksNotifier(FakeBookService(books));
      await notifier.loadInitial();

      notifier.setFilterType(ListingType.swap);

      expect(notifier.state.filterType, ListingType.swap);
      expect(notifier.state.books, [books[1]]);
    });

    test('combines search, category, and listing type filters', () async {
      final notifier = BooksNotifier(FakeBookService(books));
      await notifier.loadInitial();

      notifier.setSearch('flutter');
      notifier.setFilterCategory(BookCategory.technology);
      notifier.setFilterType(ListingType.sale);

      expect(notifier.state.books, [books[0]]);
    });

    test('clearFilters restores all loaded books', () async {
      final notifier = BooksNotifier(FakeBookService(books));
      await notifier.loadInitial();

      notifier.setSearch('history');
      notifier.setFilterType(ListingType.swap);
      notifier.clearFilters();

      expect(notifier.state.searchQuery, isEmpty);
      expect(notifier.state.filterCategory, isNull);
      expect(notifier.state.filterType, isNull);
      expect(notifier.state.books, books);
    });

    test('addListing prepends a new listing to the provider state', () async {
      final notifier = BooksNotifier(FakeBookService(books));
      await notifier.loadInitial();

      final newListing = BookListing(
        id: '3',
        title: 'Free Novel',
        author: 'Robin Page',
        price: 0,
        condition: BookCondition.likeNew,
        type: ListingType.free,
        category: BookCategory.fiction,
        description: 'A novel available for free pickup.',
        sellerName: 'Robin',
        sellerContact: 'robin@example.com',
        location: 'Cologne',
        datePosted: DateTime(2026, 5, 3),
      );

      await notifier.addListing(newListing);

      expect(notifier.state.books.first, newListing);
      expect(notifier.state.allBooks.first, newListing);
      expect(notifier.state.books.length, 3);
    });

    test('updateListing replaces an existing listing', () async {
      final notifier = BooksNotifier(FakeBookService(books));
      await notifier.loadInitial();

      final updated = books[0].copyWith(
        title: 'Flutter Basics, Second Edition',
        price: 14,
      );

      await notifier.updateListing(updated);

      expect(notifier.state.books.first.title, 'Flutter Basics, Second Edition');
      expect(notifier.state.books.first.price, 14);
      expect(notifier.state.allBooks.first, updated);
    });

    test('deleteListing removes a listing from visible and full state', () async {
      final notifier = BooksNotifier(FakeBookService(books));
      await notifier.loadInitial();

      await notifier.deleteListing('1');

      expect(notifier.state.books, [books[1]]);
      expect(notifier.state.allBooks, [books[1]]);
    });

    test('loadMore appends the next page and then stops at the end', () async {
      final pagedBooks = List.generate(12, (index) => makeBook(index + 1));
      final notifier = BooksNotifier(FakeBookService(pagedBooks));
      await notifier.loadInitial();

      expect(notifier.state.books.length, 10);
      expect(notifier.state.hasMore, isTrue);

      await notifier.loadMore();

      expect(notifier.state.books.length, 12);
      expect(notifier.state.isLoadingMore, isFalse);
      expect(notifier.state.hasMore, isFalse);

      await notifier.loadMore();

      expect(notifier.state.books.length, 12);
      expect(notifier.state.hasMore, isFalse);
    });

    test('loadInitial stores an error when the service fails', () async {
      final notifier = BooksNotifier(FailingBookService());
      await notifier.loadInitial();

      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.books, isEmpty);
      expect(notifier.state.error, contains('network unavailable'));
    });

    test('retry reloads books after the current state is changed', () async {
      final notifier = BooksNotifier(FakeBookService(books));
      await notifier.loadInitial();
      notifier.setSearch('flutter');

      expect(notifier.state.books, [books[0]]);

      await notifier.retry();

      expect(notifier.state.books, [books[0]]);
      expect(notifier.state.error, isNull);
    });

    test('Riverpod provider wires BooksNotifier to the configured service', () async {
      final container = ProviderContainer(
        overrides: [bookServiceProvider.overrideWithValue(FakeBookService(books))],
      );
      addTearDown(container.dispose);

      await container.read(booksProvider.notifier).loadInitial();

      expect(container.read(booksProvider).books, books);
    });
  });
}
