import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/browse_screen.dart';
import '../screens/search_screen.dart';
import '../screens/add_listing_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/book_detail_screen.dart';
import '../screens/about_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => HomeScreen(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'browse',
          builder: (context, state) => const BrowseScreen(),
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/add',
          name: 'add',
          builder: (context, state) => const AddListingScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/book/:id',
      name: 'bookDetail',
      builder: (context, state) => BookDetailScreen(
        id: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);
