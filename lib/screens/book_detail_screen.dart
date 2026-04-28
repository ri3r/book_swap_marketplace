import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/book_listing.dart';
import '../providers/books_provider.dart';
import '../widgets/condition_badge.dart';
import '../widgets/loading_widget.dart';

class BookDetailScreen extends ConsumerWidget {
  final String id;

  const BookDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookService = ref.read(bookServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: FutureBuilder(
        future: bookService.getBookById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Book not found'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          final book = snapshot.data!;
          final dateFormat = DateFormat('MMM dd, yyyy');

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (book.imageUrl != null)
                  CachedNetworkImage(
                    imageUrl: book.imageUrl!,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const LoadingWidget(),
                    errorWidget: (context, url, error) =>
                        Container(
                          color: Colors.grey[300],
                          height: 300,
                          child: const Icon(Icons.book, size: 80),
                        ),
                  )
                else
                  Container(
                    color: Colors.grey[300],
                    height: 300,
                    child: const Icon(Icons.book, size: 80),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        book.author,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ConditionBadge(condition: book.condition),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              book.category.displayName,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (book.type == ListingType.sale)
                        Text(
                          '€${book.price.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        Text(
                          book.type.displayName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            color: Colors.orange[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 24),
                      Text(
                        'Description',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(book.description),
                      const SizedBox(height: 24),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Seller Information',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _InfoRow(
                                icon: Icons.person,
                                label: 'Name',
                                value: book.sellerName,
                              ),
                              _InfoRow(
                                icon: Icons.email,
                                label: 'Email',
                                value: book.sellerContact,
                              ),
                              _InfoRow(
                                icon: Icons.location_on,
                                label: 'Location',
                                value: book.location,
                              ),
                              _InfoRow(
                                icon: Icons.calendar_today,
                                label: 'Posted',
                                value: dateFormat.format(book.datePosted),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (book.isbn != null) ...[
                        const SizedBox(height: 24),
                        _InfoRow(
                          icon: Icons.code,
                          label: 'ISBN',
                          value: book.isbn!,
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _contactSeller(context, book),
                          icon: const Icon(Icons.mail),
                          label: const Text('Contact Seller'),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _contactSeller(BuildContext context, dynamic book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Seller'),
        content: Text('Email: ${book.sellerContact}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
