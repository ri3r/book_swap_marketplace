import 'package:flutter/material.dart';

enum BookCondition { newBook, likeNew, good, fair, poor }

extension BookConditionX on BookCondition {
  String get displayName {
    switch (this) {
      case BookCondition.newBook: return 'New';
      case BookCondition.likeNew: return 'Like New';
      case BookCondition.good: return 'Good';
      case BookCondition.fair: return 'Fair';
      case BookCondition.poor: return 'Poor';
    }
  }

  Color get badgeColor {
    switch (this) {
      case BookCondition.newBook: return Colors.green;
      case BookCondition.likeNew: return Colors.lightGreen;
      case BookCondition.good: return Colors.amber;
      case BookCondition.fair: return Colors.orange;
      case BookCondition.poor: return Colors.red;
    }
  }

  static BookCondition fromString(String value) {
    switch (value.toLowerCase()) {
      case 'new': return BookCondition.newBook;
      case 'like_new': return BookCondition.likeNew;
      case 'fair': return BookCondition.fair;
      case 'poor': return BookCondition.poor;
      default: return BookCondition.good;
    }
  }
}

enum ListingType { sale, swap, free }

extension ListingTypeX on ListingType {
  String get displayName {
    switch (this) {
      case ListingType.sale: return 'For Sale';
      case ListingType.swap: return 'For Swap';
      case ListingType.free: return 'Free';
    }
  }

  static ListingType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'swap': return ListingType.swap;
      case 'free': return ListingType.free;
      default: return ListingType.sale;
    }
  }
}

enum BookCategory {
  fiction, nonFiction, textbook, childrens, science, history, arts, technology, other
}

extension BookCategoryX on BookCategory {
  String get displayName {
    switch (this) {
      case BookCategory.fiction: return 'Fiction';
      case BookCategory.nonFiction: return 'Non-Fiction';
      case BookCategory.textbook: return 'Textbook';
      case BookCategory.childrens: return "Children's";
      case BookCategory.science: return 'Science';
      case BookCategory.history: return 'History';
      case BookCategory.arts: return 'Arts';
      case BookCategory.technology: return 'Technology';
      case BookCategory.other: return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case BookCategory.fiction: return Icons.auto_stories;
      case BookCategory.nonFiction: return Icons.lightbulb;
      case BookCategory.textbook: return Icons.school;
      case BookCategory.childrens: return Icons.child_care;
      case BookCategory.science: return Icons.science;
      case BookCategory.history: return Icons.account_balance;
      case BookCategory.arts: return Icons.palette;
      case BookCategory.technology: return Icons.computer;
      case BookCategory.other: return Icons.book;
    }
  }

  static BookCategory fromString(String value) {
    switch (value.toLowerCase()) {
      case 'fiction': return BookCategory.fiction;
      case 'non_fiction': return BookCategory.nonFiction;
      case 'textbook': return BookCategory.textbook;
      case 'childrens': return BookCategory.childrens;
      case 'science': return BookCategory.science;
      case 'history': return BookCategory.history;
      case 'arts': return BookCategory.arts;
      case 'technology': return BookCategory.technology;
      default: return BookCategory.other;
    }
  }
}

class BookListing {
  final String id;
  final String title;
  final String author;
  final String? isbn;
  final double price;
  final BookCondition condition;
  final ListingType type;
  final BookCategory category;
  final String description;
  final String sellerName;
  final String sellerContact;
  final String? imageUrl;
  final String location;
  final DateTime datePosted;
  final bool isAvailable;

  BookListing({
    required this.id,
    required this.title,
    required this.author,
    this.isbn,
    required this.price,
    required this.condition,
    required this.type,
    required this.category,
    required this.description,
    required this.sellerName,
    required this.sellerContact,
    this.imageUrl,
    required this.location,
    required this.datePosted,
    this.isAvailable = true,
  });

  factory BookListing.fromJson(Map<String, dynamic> json) {
    return BookListing(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      isbn: json['isbn'] as String?,
      price: (json['price'] as num).toDouble(),
      condition: BookConditionX.fromString(json['condition'] as String),
      type: ListingTypeX.fromString(json['type'] as String),
      category: BookCategoryX.fromString(json['category'] as String),
      description: json['description'] as String,
      sellerName: json['sellerName'] as String,
      sellerContact: json['sellerContact'] as String,
      imageUrl: json['imageUrl'] as String?,
      location: json['location'] as String,
      datePosted: DateTime.parse(json['datePosted'] as String),
      isAvailable: (json['isAvailable'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'author': author,
    'isbn': isbn,
    'price': price,
    'condition': condition.name,
    'type': type.name,
    'category': category.name,
    'description': description,
    'sellerName': sellerName,
    'sellerContact': sellerContact,
    'imageUrl': imageUrl,
    'location': location,
    'datePosted': datePosted.toIso8601String(),
    'isAvailable': isAvailable,
  };

  BookListing copyWith({
    String? id,
    String? title,
    String? author,
    String? isbn,
    double? price,
    BookCondition? condition,
    ListingType? type,
    BookCategory? category,
    String? description,
    String? sellerName,
    String? sellerContact,
    String? imageUrl,
    String? location,
    DateTime? datePosted,
    bool? isAvailable,
  }) =>
    BookListing(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      price: price ?? this.price,
      condition: condition ?? this.condition,
      type: type ?? this.type,
      category: category ?? this.category,
      description: description ?? this.description,
      sellerName: sellerName ?? this.sellerName,
      sellerContact: sellerContact ?? this.sellerContact,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      datePosted: datePosted ?? this.datePosted,
      isAvailable: isAvailable ?? this.isAvailable,
    );
}
