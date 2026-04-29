import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boook_marketplace/models/book_listing.dart';
import 'package:boook_marketplace/widgets/app_error_widget.dart';
import 'package:boook_marketplace/widgets/condition_badge.dart';
import 'package:boook_marketplace/widgets/empty_state_widget.dart';
import 'package:boook_marketplace/widgets/loading_widget.dart';

void main() {
  group('EmptyStateWidget', () {
    testWidgets('renders title and message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              title: 'No Books Found',
              message: 'Try adjusting your filters',
            ),
          ),
        ),
      );

      expect(find.text('No Books Found'), findsOneWidget);
      expect(find.text('Try adjusting your filters'), findsOneWidget);
    });

    testWidgets('renders custom icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              title: 'Empty',
              message: 'Nothing here',
              icon: Icons.search_off,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('renders default icon when none provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              title: 'Empty',
              message: 'Nothing here',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });
  });

  group('AppErrorWidget', () {
    testWidgets('renders error message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(message: 'Network error'),
          ),
        ),
      );

      expect(find.text('Network error'), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('shows retry button when onRetry provided', (tester) async {
      bool retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(
              message: 'Failed to load',
              onRetry: () { retried = true; },
            ),
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(retried, true);
    });

    testWidgets('hides retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(message: 'Error'),
          ),
        ),
      );

      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('shows error icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(message: 'Error'),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });

  group('LoadingWidget', () {
    testWidgets('renders progress indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingWidget()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders custom message when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(message: 'Loading books...'),
          ),
        ),
      );

      expect(find.text('Loading books...'), findsOneWidget);
    });
  });

  group('ConditionBadge', () {
    testWidgets('displays correct label for each condition', (tester) async {
      for (final condition in BookCondition.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ConditionBadge(condition: condition),
            ),
          ),
        );
        expect(find.text(condition.displayName), findsOneWidget);
      }
    });

    testWidgets('renders as a Container with text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ConditionBadge(condition: BookCondition.good),
          ),
        ),
      );

      expect(find.text('Good'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });
  });
}
