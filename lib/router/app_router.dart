import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../models/book_listing.dart';
import '../screens/home_screen.dart';
import '../screens/browse_screen.dart';
import '../screens/search_screen.dart';
import '../screens/add_listing_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/my_listings_screen.dart';
import '../screens/book_detail_screen.dart';
import '../screens/about_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isAuthRoute =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';
    final requiresLogin = state.matchedLocation.endsWith('/edit');

    if (!isLoggedIn && requiresLogin) return '/login';
    if (isLoggedIn && isAuthRoute) return '/';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
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
          builder: (context, state) => AddListingScreen(
            initialListing: state.extra as BookListing?,
            showAppBar: false,
          ),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/my-listings',
          name: 'myListings',
          builder: (context, state) => const MyListingsScreen(),
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
      path: '/book/:id/edit',
      name: 'editBook',
      builder: (context, state) => AddListingScreen(
        initialListing: state.extra as BookListing?,
      ),
    ),
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);
