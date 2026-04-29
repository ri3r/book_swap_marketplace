import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boook_marketplace/models/book_listing.dart';
import 'package:boook_marketplace/providers/books_provider.dart';
import 'package:boook_marketplace/services/book_service.dart';

class FakeBookService extends BookService {
  static final List<BookListing> _testBooks = [
    BookListing(
      id: '1',
      title: 'Book One',
      author: 'Author One',
      price: 10.0,
      condition: BookCondition.good,
      type: ListingType.sale,
      category: BookCategory.fiction,
      description: 'A test book',
      sellerName: 'Seller One',
      sellerContact: 'seller1@example.com',
      location: 'City 1',
      datePosted: DateTime.now(),
    ),
    BookListing(
      id: '2',
      title: 'Book Two',
      author: 'Author Two',
      price: 15.0,
      condition: BookCondition.newBook,
      type: ListingType.sale,
      category: BookCategory.nonFiction,
      description: 'Another test book',
      sellerName: 'Seller Two',
      sellerContact: 'seller2@example.com',
      location: 'City 2',
      datePosted: DateTime.now(),
    ),
    BookListing(
      id: '3',
      title: 'Science Book',
      author: 'Science Author',
      price: 20.0,
      condition: BookCondition.fair,
      type: ListingType.swap,
      category: BookCategory.science,
      description: 'A science book',
      sellerName: 'Seller Three',
      sellerContact: 'seller3@example.com',
      location: 'City 3',
      datePosted: DateTime.now(),
    ),
  ];

  @override
  Future<List<BookListing>> loadAllBooks() async {
    return _testBooks;
  }
}

void main() {
  group('BooksNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          bookServiceProvider.overrideWithValue(FakeBookService()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('loads books on initialization', () async {
      final notifier = container.read(booksProvider.notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      final state = container.read(booksProvider);
      expect(state.books, isNotEmpty);
      expect(state.books.length, lessThanOrEqualTo(10));
      expect(state.isLoading, false);
    });

    test('search filters books correctly', () async {
      final notifier = container.read(booksProvider.notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      notifier.setSearch('Science');
      final state = container.read(booksProvider);

      expect(state.books.length, 1);
      expect(state.books.first.title, 'Science Book');
    });

    test('category filter works', () async {
      final notifier = container.read(booksProvider.notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      notifier.setFilterCategory(BookCategory.science);
      final state = container.read(booksProvider);

      expect(state.books.length, 1);
      expect(state.books.first.category, BookCategory.science);
    });

    test('listing type filter works', () async {
      final notifier = container.read(booksProvider.notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      notifier.setFilterType(ListingType.swap);
      final state = container.read(booksProvider);

      expect(state.books.length, 1);
      expect(state.books.first.type, ListingType.swap);
    });

    test('combines multiple filters', () async {
      final notifier = container.read(booksProvider.notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      notifier.setFilterCategory(BookCategory.fiction);
      notifier.setFilterType(ListingType.sale);
      final state = container.read(booksProvider);

      expect(state.books.length, 1);
      expect(state.books.first.title, 'Book One');
    });

    test('can add new listing', () async {
      final notifier = container.read(booksProvider.notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      final initialCount = container.read(booksProvider).books.length;

      final newBook = BookListing(
        id: '99',
        title: 'New Book',
        author: 'New Author',
        price: 25.0,
        condition: BookCondition.good,
        type: ListingType.sale,
        category: BookCategory.fiction,
        description: 'A newly added book',
        sellerName: 'New Seller',
        sellerContact: 'newseller@example.com',
        location: 'New City',
        datePosted: DateTime.now(),
      );

      await notifier.addListing(newBook);
      final newState = container.read(booksProvider);

      expect(newState.books.length, greaterThan(initialCount));
      expect(newState.books.first.id, '99');
    });
  });
}
