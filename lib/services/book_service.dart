import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book_listing.dart';

class BookService {
  static const String _assetPath = 'assets/data/books.json';

  Future<List<BookListing>> loadAllBooks() async {
    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => BookListing.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }

  Future<BookListing?> getBookById(String id) async {
    try {
      final books = await loadAllBooks();
      return books.firstWhere((book) => book.id == id);
    } catch (_) {
      return null;
    }
  }

  List<BookListing> searchBooks(
    List<BookListing> books,
    String query,
  ) {
    if (query.isEmpty) return books;
    final lowerQuery = query.toLowerCase();
    return books
        .where((book) =>
            book.title.toLowerCase().contains(lowerQuery) ||
            book.author.toLowerCase().contains(lowerQuery) ||
            (book.isbn?.contains(lowerQuery) ?? false))
        .toList();
  }

  List<BookListing> filterByCategory(
    List<BookListing> books,
    BookCategory category,
  ) =>
      books.where((book) => book.category == category).toList();

  List<BookListing> filterByCondition(
    List<BookListing> books,
    BookCondition condition,
  ) =>
      books.where((book) => book.condition == condition).toList();

  List<BookListing> filterByType(
    List<BookListing> books,
    ListingType type,
  ) =>
      books.where((book) => book.type == type).toList();
}
