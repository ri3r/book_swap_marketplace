import 'package:boook_marketplace/models/book_listing.dart';
import 'package:boook_marketplace/widgets/app_error_widget.dart';
import 'package:boook_marketplace/widgets/book_list_tile.dart';
import 'package:boook_marketplace/widgets/empty_state_widget.dart';
import 'package:boook_marketplace/widgets/loading_widget.dart';
import 'package:boook_marketplace/widgets/login_required_dialog.dart';
import 'package:boook_marketplace/widgets/login_required_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('Widget tests', () {
    testWidgets('EmptyStateWidget renders its configured content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              title: 'No listings yet',
              message: 'Add your first book to get started.',
              icon: Icons.menu_book,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.menu_book), findsOneWidget);
      expect(find.text('No listings yet'), findsOneWidget);
      expect(find.text('Add your first book to get started.'), findsOneWidget);
    });

    testWidgets('BookListTile renders book data and handles taps', (tester) async {
      var tapped = false;
      final book = BookListing(
        id: 'swap-1',
        title: 'The Pragmatic Programmer',
        author: 'Andrew Hunt and David Thomas',
        price: 0,
        condition: BookCondition.likeNew,
        type: ListingType.swap,
        category: BookCategory.technology,
        description: 'A modern software craftsmanship classic.',
        sellerName: 'Taylor',
        sellerContact: 'taylor@example.com',
        location: 'Dortmund',
        datePosted: DateTime(2026, 5, 10),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookListTile(
              book: book,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('The Pragmatic Programmer'), findsOneWidget);
      expect(find.text('Andrew Hunt and David Thomas'), findsOneWidget);
      expect(find.text('Like New'), findsOneWidget);
      expect(find.text('For Swap'), findsOneWidget);
      expect(find.text('Dortmund'), findsOneWidget);

      await tester.tap(find.byType(BookListTile));
      expect(tapped, isTrue);
    });

    testWidgets('BookListTile renders sale price and network cover widget', (
      tester,
    ) async {
      final book = BookListing(
        id: 'sale-1',
        title: 'Refactoring',
        author: 'Martin Fowler',
        isbn: '9780134757599',
        price: 15.25,
        condition: BookCondition.good,
        type: ListingType.sale,
        category: BookCategory.technology,
        description: 'A software design book for sale.',
        sellerName: 'Morgan',
        sellerContact: 'morgan@example.com',
        imageUrl: 'https://example.com/refactoring.jpg',
        location: 'Leipzig',
        datePosted: DateTime(2026, 5, 11),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BookListTile(
              book: book,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CachedNetworkImage), findsOneWidget);
      expect(find.textContaining('15.25'), findsOneWidget);
      expect(find.text('For Sale'), findsNothing);
    });

    testWidgets('AppErrorWidget calls retry callback when retry is tapped', (
      tester,
    ) async {
      var retryCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(
              message: 'Could not load listings.',
              onRetry: () => retryCount++,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Could not load listings.'), findsOneWidget);

      await tester.tap(find.text('Retry'));

      expect(retryCount, 1);
    });

    testWidgets('LoadingWidget shows spinner and optional message', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(message: 'Loading books...'),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading books...'), findsOneWidget);
    });

    testWidgets('LoginRequiredWidget navigates to login and register routes', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: LoginRequiredWidget(
                title: 'Sign in required',
                message: 'Please sign in to manage your listings.',
              ),
            ),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const Scaffold(body: Text('Login page')),
          ),
          GoRoute(
            path: '/register',
            builder: (context, state) =>
                const Scaffold(body: Text('Register page')),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      expect(find.text('Sign in required'), findsOneWidget);
      expect(find.text('Please sign in to manage your listings.'), findsOneWidget);

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Login page'), findsOneWidget);

      router.go('/');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Register page'), findsOneWidget);
    });

    testWidgets('showLoginRequiredDialog dismisses or navigates to sign in', (
      tester,
    ) async {
      late BuildContext pageContext;
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              pageContext = context;
              return const Scaffold(body: Text('Protected action'));
            },
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const Scaffold(body: Text('Login page')),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      final dismissFuture = showLoginRequiredDialog(
        pageContext,
        title: 'Login needed',
        message: 'Please sign in before contacting a seller.',
      );
      await tester.pumpAndSettle();

      expect(find.text('Login needed'), findsOneWidget);
      expect(find.text('Please sign in before contacting a seller.'), findsOneWidget);

      await tester.tap(find.text('Not Now'));
      await dismissFuture;
      await tester.pumpAndSettle();

      expect(find.text('Login needed'), findsNothing);
      expect(find.text('Protected action'), findsOneWidget);

      final signInFuture = showLoginRequiredDialog(
        pageContext,
        title: 'Login needed',
        message: 'Please sign in before contacting a seller.',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign In'));
      await signInFuture;
      await tester.pumpAndSettle();

      expect(find.text('Login page'), findsOneWidget);
    });
  });
}
