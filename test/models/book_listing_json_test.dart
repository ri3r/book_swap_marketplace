import 'package:boook_marketplace/models/book_listing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookListing enum helpers', () {
    test('BookCondition exposes display names, colors, and string parsing', () {
      expect(BookCondition.newBook.displayName, 'New');
      expect(BookCondition.likeNew.displayName, 'Like New');
      expect(BookCondition.good.displayName, 'Good');
      expect(BookCondition.fair.displayName, 'Fair');
      expect(BookCondition.poor.displayName, 'Poor');

      for (final condition in BookCondition.values) {
        expect(condition.badgeColor, isNotNull);
      }

      expect(BookConditionX.fromString('new'), BookCondition.newBook);
      expect(BookConditionX.fromString('like_new'), BookCondition.likeNew);
      expect(BookConditionX.fromString('fair'), BookCondition.fair);
      expect(BookConditionX.fromString('poor'), BookCondition.poor);
      expect(BookConditionX.fromString('unknown'), BookCondition.good);
    });

    test('ListingType exposes display names and string parsing', () {
      expect(ListingType.sale.displayName, 'For Sale');
      expect(ListingType.swap.displayName, 'For Swap');
      expect(ListingType.free.displayName, 'Free');

      expect(ListingTypeX.fromString('swap'), ListingType.swap);
      expect(ListingTypeX.fromString('free'), ListingType.free);
      expect(ListingTypeX.fromString('unknown'), ListingType.sale);
    });

    test('BookCategory exposes display names, icons, and string parsing', () {
      expect(BookCategory.fiction.displayName, 'Fiction');
      expect(BookCategory.nonFiction.displayName, 'Non-Fiction');
      expect(BookCategory.textbook.displayName, 'Textbook');
      expect(BookCategory.childrens.displayName, "Children's");
      expect(BookCategory.science.displayName, 'Science');
      expect(BookCategory.history.displayName, 'History');
      expect(BookCategory.arts.displayName, 'Arts');
      expect(BookCategory.technology.displayName, 'Technology');
      expect(BookCategory.other.displayName, 'Other');

      for (final category in BookCategory.values) {
        expect(category.icon, isNotNull);
      }

      expect(BookCategoryX.fromString('fiction'), BookCategory.fiction);
      expect(BookCategoryX.fromString('non_fiction'), BookCategory.nonFiction);
      expect(BookCategoryX.fromString('textbook'), BookCategory.textbook);
      expect(BookCategoryX.fromString('childrens'), BookCategory.childrens);
      expect(BookCategoryX.fromString('science'), BookCategory.science);
      expect(BookCategoryX.fromString('history'), BookCategory.history);
      expect(BookCategoryX.fromString('arts'), BookCategory.arts);
      expect(BookCategoryX.fromString('technology'), BookCategory.technology);
      expect(BookCategoryX.fromString('unknown'), BookCategory.other);
    });
  });

  group('BookListing JSON serialization', () {
    test('fromJson creates a book listing with parsed enum and date values', () {
      final listing = BookListing.fromJson({
        'id': 'book-1',
        'title': 'Clean Code',
        'author': 'Robert C. Martin',
        'isbn': '9780132350884',
        'price': 12,
        'condition': 'like_new',
        'type': 'swap',
        'category': 'technology',
        'description': 'A practical software engineering book.',
        'sellerName': 'Alex',
        'sellerContact': 'alex@example.com',
        'imageUrl': 'https://example.com/cover.jpg',
        'location': 'Berlin',
        'datePosted': '2026-05-20T12:30:00.000',
        'isAvailable': false,
        'ownerId': 'user-1',
      });

      expect(listing.id, 'book-1');
      expect(listing.title, 'Clean Code');
      expect(listing.condition, BookCondition.likeNew);
      expect(listing.type, ListingType.swap);
      expect(listing.category, BookCategory.technology);
      expect(listing.datePosted, DateTime(2026, 5, 20, 12, 30));
      expect(listing.isAvailable, isFalse);
      expect(listing.ownerId, 'user-1');
    });

    test('toJson returns all persisted fields in map form', () {
      final listing = BookListing(
        id: 'book-2',
        title: 'The Hobbit',
        author: 'J. R. R. Tolkien',
        isbn: '9780261103344',
        price: 8.5,
        condition: BookCondition.good,
        type: ListingType.sale,
        category: BookCategory.fiction,
        description: 'Classic fantasy paperback in good condition.',
        sellerName: 'Sam',
        sellerContact: 'sam@example.com',
        imageUrl: null,
        location: 'Hamburg',
        datePosted: DateTime(2026, 5, 21, 9, 15),
        isAvailable: true,
        ownerId: 'user-2',
      );

      expect(listing.toJson(), {
        'id': 'book-2',
        'title': 'The Hobbit',
        'author': 'J. R. R. Tolkien',
        'isbn': '9780261103344',
        'price': 8.5,
        'condition': 'good',
        'type': 'sale',
        'category': 'fiction',
        'description': 'Classic fantasy paperback in good condition.',
        'sellerName': 'Sam',
        'sellerContact': 'sam@example.com',
        'imageUrl': null,
        'location': 'Hamburg',
        'datePosted': '2026-05-21T09:15:00.000',
        'isAvailable': true,
        'ownerId': 'user-2',
      });
    });

    test('fromJson defaults optional availability to true', () {
      final listing = BookListing.fromJson({
        'id': 'book-3',
        'title': 'Default Availability',
        'author': 'Casey',
        'isbn': null,
        'price': 0,
        'condition': 'unknown',
        'type': 'unknown',
        'category': 'unknown',
        'description': 'Checks defaults and enum fallbacks.',
        'sellerName': 'Casey',
        'sellerContact': 'casey@example.com',
        'imageUrl': null,
        'location': 'Bonn',
        'datePosted': '2026-05-22T08:00:00.000',
      });

      expect(listing.isAvailable, isTrue);
      expect(listing.condition, BookCondition.good);
      expect(listing.type, ListingType.sale);
      expect(listing.category, BookCategory.other);
    });
  });

  group('BookListing helpers', () {
    final listing = BookListing(
      id: 'original',
      title: 'Original Title',
      author: 'Original Author',
      isbn: '1234567890',
      price: 5,
      condition: BookCondition.fair,
      type: ListingType.swap,
      category: BookCategory.history,
      description: 'Original description text.',
      sellerName: 'Original Seller',
      sellerContact: 'original@example.com',
      imageUrl: null,
      location: 'Original City',
      datePosted: DateTime(2026, 5, 23),
      isAvailable: true,
      ownerId: 'owner-original',
    );

    test('coverUrl prefers imageUrl, falls back to ISBN, then null', () {
      expect(
        listing.copyWith(imageUrl: 'https://example.com/custom.jpg').coverUrl,
        'https://example.com/custom.jpg',
      );
      expect(
        listing.coverUrl,
        'https://covers.openlibrary.org/b/isbn/1234567890-M.jpg',
      );
      expect(
        BookListing(
          id: 'no-cover',
          title: 'No Cover',
          author: 'No Author',
          price: 0,
          condition: BookCondition.good,
          type: ListingType.free,
          category: BookCategory.other,
          description: 'No cover information is available.',
          sellerName: 'No Seller',
          sellerContact: 'no@example.com',
          location: 'No City',
          datePosted: DateTime(2026, 5, 24),
        ).coverUrl,
        isNull,
      );
    });

    test('copyWith overrides supplied fields and preserves the rest', () {
      final updated = listing.copyWith(
        id: 'updated',
        title: 'Updated Title',
        author: 'Updated Author',
        isbn: '0987654321',
        price: 12.5,
        condition: BookCondition.newBook,
        type: ListingType.sale,
        category: BookCategory.technology,
        description: 'Updated description text.',
        sellerName: 'Updated Seller',
        sellerContact: 'updated@example.com',
        imageUrl: 'https://example.com/updated.jpg',
        location: 'Updated City',
        datePosted: DateTime(2026, 5, 25),
        isAvailable: false,
        ownerId: 'owner-updated',
      );

      expect(updated.id, 'updated');
      expect(updated.title, 'Updated Title');
      expect(updated.author, 'Updated Author');
      expect(updated.isbn, '0987654321');
      expect(updated.price, 12.5);
      expect(updated.condition, BookCondition.newBook);
      expect(updated.type, ListingType.sale);
      expect(updated.category, BookCategory.technology);
      expect(updated.description, 'Updated description text.');
      expect(updated.sellerName, 'Updated Seller');
      expect(updated.sellerContact, 'updated@example.com');
      expect(updated.imageUrl, 'https://example.com/updated.jpg');
      expect(updated.location, 'Updated City');
      expect(updated.datePosted, DateTime(2026, 5, 25));
      expect(updated.isAvailable, isFalse);
      expect(updated.ownerId, 'owner-updated');

      expect(listing.copyWith().toJson(), listing.toJson());
    });
  });
}
