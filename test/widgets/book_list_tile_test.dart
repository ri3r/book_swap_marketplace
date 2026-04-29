import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boook_marketplace/models/book_listing.dart';
import 'package:boook_marketplace/widgets/book_list_tile.dart';
import 'package:boook_marketplace/theme/app_theme.dart';

void main() {
  group('BookListTile', () {
    final testBook = BookListing(
      id: '1',
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      isbn: '9780743273565',
      price: 9.99,
      condition: BookCondition.good,
      type: ListingType.sale,
      category: BookCategory.fiction,
      description: 'A classic American novel',
      sellerName: 'John Doe',
      sellerContact: 'john@example.com',
      imageUrl: null,
      location: 'Munich, Germany',
      datePosted: DateTime(2024, 1, 15),
      isAvailable: true,
    );

    testWidgets('renders book title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: BookListTile(
              book: testBook,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('The Great Gatsby'), findsOneWidget);
    });

    testWidgets('renders author name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: BookListTile(
              book: testBook,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('F. Scott Fitzgerald'), findsOneWidget);
    });

    testWidgets('renders price for sale listing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: BookListTile(
              book: testBook,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('€9.99'), findsOneWidget);
    });

    testWidgets('renders location', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: BookListTile(
              book: testBook,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Munich, Germany'), findsOneWidget);
    });

    testWidgets('shows condition badge', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: BookListTile(
              book: testBook,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Good'), findsOneWidget);
    });

    testWidgets('calls onTap callback when tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: BookListTile(
              book: testBook,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, true);
    });

    testWidgets('renders swap listing type', (WidgetTester tester) async {
      final swapBook = testBook.copyWith(type: ListingType.swap);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: BookListTile(
              book: swapBook,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('For Swap'), findsOneWidget);
    });

    testWidgets('displays default book icon when no image and no isbn', (WidgetTester tester) async {
      final noImageBook = BookListing(
        id: '2',
        title: 'No Cover Book',
        author: 'Unknown',
        price: 5.00,
        condition: BookCondition.fair,
        type: ListingType.sale,
        category: BookCategory.other,
        description: 'No image or isbn',
        sellerName: 'Jane',
        sellerContact: 'jane@example.com',
        location: 'Berlin',
        datePosted: DateTime(2024, 1, 1),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: BookListTile(
              book: noImageBook,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.book), findsOneWidget);
    });
  });
}
