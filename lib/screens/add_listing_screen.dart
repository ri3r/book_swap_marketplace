import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/book_listing.dart';
import '../providers/auth_provider.dart';
import '../providers/books_provider.dart';
import '../utils/validators.dart';
import '../widgets/login_required_widget.dart';

class AddListingScreen extends ConsumerStatefulWidget {
  final BookListing? initialListing;
  final bool showAppBar;

  const AddListingScreen({
    super.key,
    this.initialListing,
    this.showAppBar = true,
  });

  @override
  ConsumerState<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends ConsumerState<AddListingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController,
      _authorController,
      _priceController,
      _descriptionController,
      _locationController,
      _contactController,
      _isbnController,
      _imageUrlController,
      _sellerNameController;

  late BookCondition _selectedCondition;
  late ListingType _selectedType;
  late BookCategory _selectedCategory;

  bool get _isEditing => widget.initialListing != null;

  @override
  void initState() {
    super.initState();
    final b = widget.initialListing;
    final user = ref.read(currentUserProvider);
    _titleController = TextEditingController(text: b?.title ?? '');
    _authorController = TextEditingController(text: b?.author ?? '');
    _priceController = TextEditingController(
      text: (b?.type == ListingType.sale && b?.price != null)
          ? b!.price.toString()
          : '',
    );
    _descriptionController = TextEditingController(text: b?.description ?? '');
    _locationController = TextEditingController(text: b?.location ?? '');
    _contactController = TextEditingController(
        text: b?.sellerContact ?? user?.email ?? '');
    _isbnController = TextEditingController(text: b?.isbn ?? '');
    _imageUrlController = TextEditingController(text: b?.imageUrl ?? '');
    _sellerNameController = TextEditingController(
        text: b?.sellerName ?? user?.displayName ?? '');
    _selectedCondition = b?.condition ?? BookCondition.good;
    _selectedType = b?.type ?? ListingType.sale;
    _selectedCategory = b?.category ?? BookCategory.other;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _isbnController.dispose();
    _imageUrlController.dispose();
    _sellerNameController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isEditing) {
      final updated = widget.initialListing!.copyWith(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        isbn: _isbnController.text.isEmpty ? null : _isbnController.text.trim(),
        price: _selectedType == ListingType.sale
            ? double.parse(
                _priceController.text.isEmpty ? '0' : _priceController.text)
            : 0,
        condition: _selectedCondition,
        type: _selectedType,
        category: _selectedCategory,
        description: _descriptionController.text.trim(),
        sellerName: _sellerNameController.text.trim(),
        sellerContact: _contactController.text.trim(),
        imageUrl: _imageUrlController.text.isEmpty
            ? null
            : _imageUrlController.text.trim(),
        location: _locationController.text.trim(),
      );
      await ref.read(booksProvider.notifier).updateListing(updated);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing updated!')),
      );
      context.pop();
    } else {
      final user = ref.read(currentUserProvider);
      final newListing = BookListing(
        id: FirebaseFirestore.instance.collection('books').doc().id,
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        isbn: _isbnController.text.isEmpty ? null : _isbnController.text.trim(),
        price: _selectedType == ListingType.sale
            ? double.parse(
                _priceController.text.isEmpty ? '0' : _priceController.text)
            : 0,
        condition: _selectedCondition,
        type: _selectedType,
        category: _selectedCategory,
        description: _descriptionController.text.trim(),
        sellerName: _sellerNameController.text.trim(),
        sellerContact: _contactController.text.trim(),
        imageUrl: _imageUrlController.text.isEmpty
            ? null
            : _imageUrlController.text.trim(),
        location: _locationController.text.trim(),
        datePosted: DateTime.now(),
        ownerId: user?.uid,
      );
      try {
        await ref.read(booksProvider.notifier).addListing(newListing);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing added successfully!')),
        );
        context.go('/book/${newListing.id}');
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add listing.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditing ? 'Edit Listing' : 'Add Book Listing';
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(
        body: LoginRequiredWidget(
          title: 'Sign in to add books',
          message: 'Create an account or sign in to list books on BookHero.',
          icon: Icons.add_circle_outline,
        ),
      );
    }

    return Scaffold(
      appBar: widget.showAppBar ? AppBar(title: Text(title)) : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!widget.showAppBar) ...[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                ],
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Book Title *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.validateTitle,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _authorController,
                  decoration: InputDecoration(
                    labelText: 'Author *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.validateAuthor,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _sellerNameController,
                  decoration: InputDecoration(
                    labelText: 'Your Name *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Name required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: 'Email Address *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.validateLocation,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<BookCategory>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: BookCategory.values
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat.displayName),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<BookCondition>(
                  initialValue: _selectedCondition,
                  decoration: InputDecoration(
                    labelText: 'Condition *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: BookCondition.values
                      .map((cond) => DropdownMenuItem(
                            value: cond,
                            child: Text(cond.displayName),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCondition = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ListingType>(
                  initialValue: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'Listing Type *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ListingType.values
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.displayName),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedType = value);
                    }
                  },
                ),
                if (_selectedType == ListingType.sale) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Price (€) *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: Validators.validatePrice,
                  ),
                ],
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 4,
                  validator: Validators.validateDescription,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _isbnController,
                  decoration: InputDecoration(
                    labelText: 'ISBN (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.validateIsbn,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    labelText: 'Image URL (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'https://example.com/image.jpg',
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(_isEditing ? 'Save Changes' : 'Post Listing'),
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
