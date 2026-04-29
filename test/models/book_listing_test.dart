import 'package:flutter_test/flutter_test.dart';
import 'package:boook_marketplace/models/book_listing.dart';

void main() {
  group('BookListing', () {
    const testJson = {
      'id': 'test-1',
      'title': 'The Great Gatsby',
      'author': 'F. Scott Fitzgerald',
      'isbn': '9780743273565',
      'price': 9.99,
      'condition': 'good',
      'type': 'sale',
      'category': 'fiction',
      'description': 'A classic American novel.',
      'sellerName': 'John Doe',
      'sellerContact': 'john@example.com',
      'imageUrl': 'https://example.com/book.jpg',
      'location': 'Munich, Germany',
      'datePosted': '2024-01-15T10:00:00.000Z',
      'isAvailable': true,
    };

    test('fromJson creates BookListing correctly', () {
      final book = BookListing.fromJson(testJson);

      expect(book.id, 'test-1');
      expect(book.title, 'The Great Gatsby');
      expect(book.author, 'F. Scott Fitzgerald');
      expect(book.isbn, '9780743273565');
      expect(book.price, 9.99);
      expect(book.condition, BookCondition.good);
      expect(book.type, ListingType.sale);
      expect(book.category, BookCategory.fiction);
      expect(book.isAvailable, true);
    });

    test('toJson serializes BookListing correctly', () {
      final book = BookListing.fromJson(testJson);
      final json = book.toJson();

      expect(json['id'], 'test-1');
      expect(json['title'], 'The Great Gatsby');
      expect(json['author'], 'F. Scott Fitzgerald');
      expect(json['price'], 9.99);
      expect(json['condition'], 'good');
      expect(json['type'], 'sale');
      expect(json['category'], 'fiction');
    });

    test('copyWith creates modified copy', () {
      final book = BookListing.fromJson(testJson);
      final modified = book.copyWith(title: 'New Title', price: 15.99);

      expect(modified.title, 'New Title');
      expect(modified.price, 15.99);
      expect(modified.author, book.author);
    });

    test('handles null optional fields', () {
      const jsonWithoutOptionals = {
        'id': 'test-2',
        'title': 'Sample Book',
        'author': 'Author Name',
        'price': 12.99,
        'condition': 'new',
        'type': 'swap',
        'category': 'fiction',
        'description': 'A book',
        'sellerName': 'Seller',
        'sellerContact': 'seller@example.com',
        'location': 'City',
        'datePosted': '2024-01-15T10:00:00.000Z',
      };

      final book = BookListing.fromJson(jsonWithoutOptionals);
      expect(book.isbn, isNull);
      expect(book.imageUrl, isNull);
      expect(book.isAvailable, true);
    });

    test('BookCondition enum extensions work', () {
      expect(BookCondition.newBook.displayName, 'New');
      expect(BookCondition.good.displayName, 'Good');
      expect(BookConditionX.fromString('good'), BookCondition.good);
    });

    test('ListingType enum extensions work', () {
      expect(ListingType.sale.displayName, 'For Sale');
      expect(ListingType.swap.displayName, 'For Swap');
      expect(ListingTypeX.fromString('swap'), ListingType.swap);
    });

    test('BookCategory enum extensions work', () {
      expect(BookCategory.fiction.displayName, 'Fiction');
      expect(BookCategoryX.fromString('fiction'), BookCategory.fiction);
    });
  });
}
