import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/book_listing.dart';
import '../providers/books_provider.dart';
import '../providers/my_listings_provider.dart';
import '../utils/validators.dart';

class AddListingScreen extends ConsumerStatefulWidget {
  final BookListing? initialListing;

  const AddListingScreen({super.key, this.initialListing});

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
    _titleController = TextEditingController(text: b?.title ?? '');
    _authorController = TextEditingController(text: b?.author ?? '');
    _priceController = TextEditingController(
      text: (b?.type == ListingType.sale && b?.price != null)
          ? b!.price.toString()
          : '',
    );
    _descriptionController = TextEditingController(text: b?.description ?? '');
    _locationController = TextEditingController(text: b?.location ?? '');
    _contactController = TextEditingController(text: b?.sellerContact ?? '');
    _isbnController = TextEditingController(text: b?.isbn ?? '');
    _imageUrlController = TextEditingController(text: b?.imageUrl ?? '');
    _sellerNameController = TextEditingController(text: b?.sellerName ?? '');
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

  void _submitForm() {
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
      ref.read(booksProvider.notifier).updateListing(updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing updated!')),
      );
      context.pop();
    } else {
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
      );
      ref.read(booksProvider.notifier).addListing(newListing);
      ref.read(myListingsProvider.notifier).add(newListing.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing added successfully!')),
      );
      _formKey.currentState!.reset();
      _clearControllers();
    }
  }

  void _clearControllers() {
    for (final c in [
      _titleController,
      _authorController,
      _priceController,
      _descriptionController,
      _locationController,
      _contactController,
      _isbnController,
      _imageUrlController,
      _sellerNameController,
    ]) {
      c.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Listing' : 'Add Book Listing'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  value: _selectedCategory,
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
                  value: _selectedCondition,
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
                  value: _selectedType,
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
