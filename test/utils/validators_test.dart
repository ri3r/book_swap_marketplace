import 'package:boook_marketplace/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    test('validateTitle requires a 2 to 200 character title', () {
      expect(Validators.validateTitle(null), 'Title is required');
      expect(Validators.validateTitle(' '), 'Title is required');
      expect(Validators.validateTitle('A'), 'Title must be at least 2 characters');
      expect(
        Validators.validateTitle('A' * 201),
        'Title must not exceed 200 characters',
      );
      expect(Validators.validateTitle('Dune'), isNull);
    });

    test('validateAuthor requires at least 2 characters', () {
      expect(Validators.validateAuthor(null), 'Author is required');
      expect(Validators.validateAuthor(' '), 'Author is required');
      expect(Validators.validateAuthor('A'), 'Author must be at least 2 characters');
      expect(Validators.validateAuthor('Frank Herbert'), isNull);
    });

    test('validateEmail requires a valid email address', () {
      expect(Validators.validateEmail(null), 'Email is required');
      expect(Validators.validateEmail('reader'), 'Enter a valid email address');
      expect(Validators.validateEmail('reader@example.com'), isNull);
    });

    test('validatePrice allows empty optional values and checks bounds', () {
      expect(Validators.validatePrice(null), isNull);
      expect(Validators.validatePrice(''), isNull);
      expect(Validators.validatePrice('abc'), 'Enter a valid number');
      expect(Validators.validatePrice('-1'), 'Price cannot be negative');
      expect(Validators.validatePrice('10000'), 'Price seems too high');
      expect(Validators.validatePrice('12.50'), isNull);
    });

    test('validateDescription requires 10 to 1000 characters', () {
      expect(Validators.validateDescription(null), 'Description is required');
      expect(Validators.validateDescription('short'), 'Description must be at least 10 characters');
      expect(
        Validators.validateDescription('A' * 1001),
        'Description must not exceed 1000 characters',
      );
      expect(Validators.validateDescription('A helpful book description.'), isNull);
    });

    test('validateLocation requires at least 2 characters', () {
      expect(Validators.validateLocation(null), 'Location is required');
      expect(Validators.validateLocation('A'), 'Enter a valid location');
      expect(Validators.validateLocation('Berlin'), isNull);
    });

    test('validateIsbn allows empty optional values and checks digit length', () {
      expect(Validators.validateIsbn(null), isNull);
      expect(Validators.validateIsbn(''), isNull);
      expect(Validators.validateIsbn('123'), 'ISBN must be 10 or 13 digits');
      expect(Validators.validateIsbn('123456789X'), 'ISBN must contain only digits');
      expect(Validators.validateIsbn('978-0-13-235088-4'), isNull);
    });

    test('validatePassword requires at least 6 characters', () {
      expect(Validators.validatePassword(null), 'Password is required');
      expect(Validators.validatePassword('12345'), 'Password must be at least 6 characters');
      expect(Validators.validatePassword('123456'), isNull);
    });

    test('validateSearch requires at least 2 characters', () {
      expect(Validators.validateSearch(null), 'Enter a search term');
      expect(Validators.validateSearch('A'), 'Search term must be at least 2 characters');
      expect(Validators.validateSearch('Dune'), isNull);
    });
  });
}
