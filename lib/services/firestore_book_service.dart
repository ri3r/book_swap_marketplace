import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_listing.dart';
import 'book_service.dart';

class FirestoreBookService extends BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _booksCollection = 'books';

  @override
  Future<List<BookListing>> loadAllBooks() async {
    try {
      final snapshot = await _firestore.collection(_booksCollection).get();
      if (snapshot.docs.isEmpty) {
        // If Firestore is empty, seed with local data
        final localBooks = await super.loadAllBooks();
        for (final book in localBooks) {
          await _firestore
              .collection(_booksCollection)
              .doc(book.id)
              .set(book.toJson());
        }
        return localBooks;
      }
      return snapshot.docs
          .map((doc) => BookListing.fromJson(doc.data()))
          .toList();
    } catch (e) {
      // Fallback to local JSON if Firebase fails
      return super.loadAllBooks();
    }
  }

  @override
  Future<BookListing?> getBookById(String id) async {
    try {
      final doc =
          await _firestore.collection(_booksCollection).doc(id).get();
      if (doc.exists) {
        return BookListing.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      // Fallback to local data
      return super.getBookById(id);
    }
  }

  Future<void> saveBook(BookListing book) async {
    try {
      await _firestore
          .collection(_booksCollection)
          .doc(book.id)
          .set(book.toJson());
    } catch (e) {
      throw Exception('Failed to save book: $e');
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      await _firestore.collection(_booksCollection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }
}
