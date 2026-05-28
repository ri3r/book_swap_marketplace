import 'package:boook_marketplace/models/book_listing.dart';
import 'package:boook_marketplace/services/book_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BookService collection logic', () {
    final service = BookService();
    final books = [
      BookListing(
        id: '1',
        title: 'Flutter in Action',
        author: 'Eric Windmill',
        isbn: '9781617296147',
        price: 18,
        condition: BookCondition.good,
        type: ListingType.sale,
        category: BookCategory.technology,
        description: 'A practical guide to Flutter development.',
        sellerName: 'Mia',
        sellerContact: 'mia@example.com',
        location: 'Berlin',
        datePosted: DateTime(2026, 5, 1),
      ),
      BookListing(
        id: '2',
        title: 'History of Design',
        author: 'Pat Kirkham',
        price: 0,
        condition: BookCondition.fair,
        type: ListingType.free,
        category: BookCategory.history,
        description: 'An illustrated introduction to design history.',
        sellerName: 'Noah',
        sellerContact: 'noah@example.com',
        location: 'Munich',
        datePosted: DateTime(2026, 5, 2),
      ),
      BookListing(
        id: '3',
        title: 'Swap Stories',
        author: 'Lea Bauer',
        price: 0,
        condition: BookCondition.likeNew,
        type: ListingType.swap,
        category: BookCategory.fiction,
        description: 'Short stories offered for exchange.',
        sellerName: 'Lea',
        sellerContact: 'lea@example.com',
        location: 'Cologne',
        datePosted: DateTime(2026, 5, 3),
      ),
    ];

    test('searchBooks finds matches by title, author, or ISBN', () {
      expect(service.searchBooks(books, 'flutter'), [books[0]]);
      expect(service.searchBooks(books, 'kirkham'), [books[1]]);
      expect(service.searchBooks(books, '9781617296147'), [books[0]]);
    });

    test('searchBooks returns the original list for an empty query', () {
      expect(service.searchBooks(books, ''), books);
    });

    test('filterByCategory returns only books in the selected category', () {
      expect(service.filterByCategory(books, BookCategory.fiction), [books[2]]);
    });

    test('filterByType returns only books with the selected listing type', () {
      expect(service.filterByType(books, ListingType.free), [books[1]]);
    });

    test('loadAllBooks reads bundled asset data into listings', () async {
      final loadedBooks = await service.loadAllBooks();

      expect(loadedBooks, isNotEmpty);
      expect(loadedBooks.first.id, '1');
      expect(loadedBooks.first.title, 'The Great Gatsby');
      expect(loadedBooks.first.condition, BookCondition.good);
      expect(loadedBooks.first.type, ListingType.sale);
      expect(loadedBooks.first.category, BookCategory.fiction);
    });

    test('getBookById returns a matching asset book or null', () async {
      final existing = await service.getBookById('1');
      final missing = await service.getBookById('missing-id');

      expect(existing, isNotNull);
      expect(existing!.title, 'The Great Gatsby');
      expect(missing, isNull);
    });
  });
}
