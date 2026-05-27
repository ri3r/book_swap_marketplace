import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location == '/') return 0;
    if (location == '/add') return 1;
    if (location == '/search') return 2;
    return -1;
  }

  void _onNavTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        return;
      case 1:
        context.go('/add');
        return;
      case 2:
        context.go('/search');
        return;
    }
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authServiceProvider).signOut();
      if (context.mounted) context.go('/login');
    }
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 58,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? colorScheme.primaryContainer.withAlpha((0.2 * 255).round())
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          size: 22,
          color: active ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final itemColor = color ?? theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: ListTile(
        minLeadingWidth: 0,
        horizontalTitleGap: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: itemColor.withAlpha((0.1 * 255).round()),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: itemColor),
        ),
        title: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: color ?? theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = _getSelectedIndex(context);
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final userEmail = user?.email;
    final isGuest = user == null;
    final userName = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : userEmail ?? 'Browsing as guest';
    final userInitial = userName[0].toUpperCase();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final drawerWidth = screenWidth < 380 ? screenWidth * 0.86 : 328.0;

    return Scaffold(
      drawer: Drawer(
        width: drawerWidth,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.pop(context),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: theme.colorScheme.surface,
                    elevation: 18,
                    shadowColor: Colors.black.withAlpha(90),
                    borderRadius: BorderRadius.circular(28),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface.withAlpha(226),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: theme.colorScheme.outlineVariant
                                      .withAlpha(120),
                                ),
                              ),
                              child: isGuest
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 24,
                                              backgroundColor: theme
                                                  .colorScheme
                                                  .primaryContainer,
                                              child: Icon(
                                                Icons.person_outline,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Browsing as guest',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: theme
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'Sign in to list books and contact sellers.',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: theme
                                                        .textTheme.bodySmall
                                                        ?.copyWith(
                                                      color: theme.colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          width: double.infinity,
                                          child: FilledButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              context.go('/login');
                                            },
                                            child: const Text('Sign In'),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundColor:
                                              theme.colorScheme.primary,
                                          child: Text(
                                            userInitial,
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                userName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: theme
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              if (userEmail != null &&
                                                  userEmail != userName) ...[
                                                const SizedBox(height: 2),
                                                Text(
                                                  userEmail,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: theme.colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                        ),
                        const SizedBox(height: 10),
                        _buildDrawerItem(
                          context,
                          icon: Icons.library_books_outlined,
                          label: 'My Listings',
                          onTap: () {
                            final currentLocation =
                                GoRouterState.of(context).uri.toString();
                            final myListingsLocation = Uri(
                              path: '/my-listings',
                              queryParameters:
                                  currentLocation == '/my-listings'
                                  ? null
                                  : {'from': currentLocation},
                            ).toString();
                            Navigator.pop(context);
                            context.go(myListingsLocation);
                          },
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.settings,
                          label: 'Settings',
                          onTap: () {
                            final currentLocation =
                                GoRouterState.of(context).uri.toString();
                            final settingsLocation = Uri(
                              path: '/settings',
                              queryParameters: currentLocation == '/settings'
                                  ? null
                                  : {'from': currentLocation},
                            ).toString();
                            Navigator.pop(context);
                            context.go(settingsLocation);
                          },
                        ),
                        if (!isGuest) ...[
                          const SizedBox(height: 18),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                              color: theme.colorScheme.outlineVariant,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildDrawerItem(
                            context,
                            icon: Icons.logout,
                            label: 'Sign Out',
                            color: theme.colorScheme.error,
                            onTap: () async {
                              Navigator.pop(context);
                              await _confirmSignOut(context, ref);
                            },
                          ),
                        ],
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 56),
              child: child,
            ),
            Positioned(
              top: 4,
              left: 12,
              child: Builder(
                builder: (context) => Material(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  elevation: 2,
                  child: IconButton(
                    tooltip: 'Menu',
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Container(
            height: 84,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.light
                  ? const Color(0xFFF8F9FA)
                  : theme.cardColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.12 * 255).round()),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: _buildNavItem(
                      context,
                      icon: Icons.home,
                      active: selectedIndex == 0,
                      onTap: () => _onNavTapped(0, context),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(
                          (0.35 * 255).round(),
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => _onNavTapped(1, context),
                    icon: Icon(
                      Icons.add,
                      color: theme.colorScheme.onPrimary,
                      size: 28,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: _buildNavItem(
                      context,
                      icon: Icons.search,
                      active: selectedIndex == 2,
                      onTap: () => _onNavTapped(2, context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
