import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About BookSwap')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.book,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'BookSwap',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version 1.0.0',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'About This App',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'BookSwap is a mobile application designed to help book '
                'enthusiasts swap and buy books with others in their community. '
                'Browse through a wide selection of books, post your own listings, '
                'and connect with fellow readers.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Text(
                'Developers',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _ContactCard(
                name: 'Gino Chianese',
                email: 'gino.chianese@study.thws.de',
                location: 'Würzburg, Germany',
              ),
              const SizedBox(height: 12),
              _ContactCard(
                name: 'Elisa Holzheid',
                email: 'elisa.holzheid@study.thws.de',
                location: 'Würzburg, Germany',
              ),
              const SizedBox(height: 12),
              _ContactCard(
                name: 'Edin Putzu',
                email: 'edin.putzu@study.thws.de',
                location: 'Würzburg, Germany',
              ),
              const SizedBox(height: 32),
              Text(
                'Features',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _FeatureItem('Browse and search through thousands of books'),
              _FeatureItem('Post your own book listings'),
              _FeatureItem('Connect with sellers and fellow readers'),
              _FeatureItem('Multiple listing types: Sale, Swap, Free'),
              _FeatureItem('Dark and light themes'),
              _FeatureItem('Advanced filtering and search'),
              const SizedBox(height: 32),
              Text(
                'Technology',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _TechItem('Flutter', 'Cross-platform mobile framework'),
              _TechItem('Riverpod', 'State management'),
              _TechItem('Go Router', 'Navigation'),
              _TechItem('Shared Preferences', 'Local data persistence'),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String name;
  final String email;
  final String location;

  const _ContactCard({
    required this.name,
    required this.email,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.email, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Text(email),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Text(location),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.check_circle,
              size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _TechItem extends StatelessWidget {
  final String name;
  final String description;

  const _TechItem(this.name, this.description);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
