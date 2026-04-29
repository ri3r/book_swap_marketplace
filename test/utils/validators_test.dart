import 'package:flutter_test/flutter_test.dart';
import 'package:boook_marketplace/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateTitle', () {
      test('returns error for empty title', () {
        expect(Validators.validateTitle(''), isNotNull);
        expect(Validators.validateTitle(null), isNotNull);
      });

      test('returns error for title too short', () {
        expect(Validators.validateTitle('a'), isNotNull);
      });

      test('returns error for title too long', () {
        expect(Validators.validateTitle('a' * 201), isNotNull);
      });

      test('returns null for valid title', () {
        expect(Validators.validateTitle('The Great Gatsby'), isNull);
        expect(Validators.validateTitle('ab'), isNull);
      });
    });

    group('validateAuthor', () {
      test('returns error for empty author', () {
        expect(Validators.validateAuthor(''), isNotNull);
        expect(Validators.validateAuthor(null), isNotNull);
      });

      test('returns error for author too short', () {
        expect(Validators.validateAuthor('a'), isNotNull);
      });

      test('returns null for valid author', () {
        expect(Validators.validateAuthor('F. Scott Fitzgerald'), isNull);
      });
    });

    group('validateEmail', () {
      test('returns error for empty email', () {
        expect(Validators.validateEmail(''), isNotNull);
        expect(Validators.validateEmail(null), isNotNull);
      });

      test('returns error for invalid email format', () {
        expect(Validators.validateEmail('notanemail'), isNotNull);
        expect(Validators.validateEmail('user@'), isNotNull);
        expect(Validators.validateEmail('@example.com'), isNotNull);
      });

      test('returns null for valid email', () {
        expect(Validators.validateEmail('user@example.com'), isNull);
        expect(Validators.validateEmail('test.user+tag@example.co.uk'), isNull);
      });
    });

    group('validatePrice', () {
      test('returns null for empty price (optional)', () {
        expect(Validators.validatePrice(''), isNull);
        expect(Validators.validatePrice(null), isNull);
      });

      test('returns error for non-numeric price', () {
        expect(Validators.validatePrice('abc'), isNotNull);
      });

      test('returns error for negative price', () {
        expect(Validators.validatePrice('-10'), isNotNull);
      });

      test('returns error for price too high', () {
        expect(Validators.validatePrice('10000'), isNotNull);
      });

      test('returns null for valid price', () {
        expect(Validators.validatePrice('9.99'), isNull);
        expect(Validators.validatePrice('100'), isNull);
        expect(Validators.validatePrice('0'), isNull);
      });
    });

    group('validateDescription', () {
      test('returns error for empty description', () {
        expect(Validators.validateDescription(''), isNotNull);
        expect(Validators.validateDescription(null), isNotNull);
      });

      test('returns error for description too short', () {
        expect(Validators.validateDescription('short'), isNotNull);
      });

      test('returns error for description too long', () {
        expect(Validators.validateDescription('a' * 1001), isNotNull);
      });

      test('returns null for valid description', () {
        expect(
          Validators.validateDescription('This is a great book that everyone should read'),
          isNull,
        );
      });
    });

    group('validateLocation', () {
      test('returns error for empty location', () {
        expect(Validators.validateLocation(''), isNotNull);
        expect(Validators.validateLocation(null), isNotNull);
      });

      test('returns error for location too short', () {
        expect(Validators.validateLocation('a'), isNotNull);
      });

      test('returns null for valid location', () {
        expect(Validators.validateLocation('Munich, Germany'), isNull);
        expect(Validators.validateLocation('NY'), isNull);
      });
    });

    group('validateIsbn', () {
      test('returns null for empty ISBN (optional)', () {
        expect(Validators.validateIsbn(''), isNull);
        expect(Validators.validateIsbn(null), isNull);
      });

      test('returns error for invalid ISBN length', () {
        expect(Validators.validateIsbn('123'), isNotNull);
        expect(Validators.validateIsbn('123456789014'), isNotNull);
      });

      test('returns error for non-numeric ISBN', () {
        expect(Validators.validateIsbn('978074327356X'), isNotNull);
      });

      test('returns null for valid 10-digit ISBN', () {
        expect(Validators.validateIsbn('0743273565'), isNull);
      });

      test('returns null for valid 13-digit ISBN', () {
        expect(Validators.validateIsbn('9780743273565'), isNull);
      });

      test('handles ISBN with dashes and spaces', () {
        expect(Validators.validateIsbn('978-0-743-27356-5'), isNull);
        expect(Validators.validateIsbn('978 0 743 27356 5'), isNull);
      });
    });

    group('validateSearch', () {
      test('returns error for empty search', () {
        expect(Validators.validateSearch(''), isNotNull);
        expect(Validators.validateSearch(null), isNotNull);
      });

      test('returns error for search too short', () {
        expect(Validators.validateSearch('a'), isNotNull);
      });

      test('returns null for valid search', () {
        expect(Validators.validateSearch('The Great Gatsby'), isNull);
        expect(Validators.validateSearch('ab'), isNull);
      });
    });
  });
}
