import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:granth/models/book_model.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // helper to get current user's saved books collection
  CollectionReference get _savedBooks => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('savedBooks');

  String _cleanId(String id) => id.replaceAll('/', '_');

  Future<void> saveBook(Book book) async {
    try {
      print('Saving book: ${book.id} for user: ${_auth.currentUser?.uid}');
      await _savedBooks.doc(_cleanId(book.id)).set(book.toMap());
    } catch (e) {
      print('Error saving book: $e');
    }
  }

  Future<void> unsaveBook(String bookId) async {
    try {
      await _savedBooks.doc(_cleanId(bookId)).delete();
    } catch (e) {
      print('Error removing book: $e');
    }
  }

  Future<bool> isBookSaved(String bookId) async {
    try {
      final doc = await _savedBooks.doc(_cleanId(bookId)).get();
      return doc.exists;
    } catch (e) {
      print('Error checking book: $e');
      return false;
    }
  }

  Future<List<Book>> getSavedBooks() async {
    try {
      final snapshot = await _savedBooks.get();
      return snapshot.docs
          .map(
            (doc) => Book(
              id: doc['id'],
              title: doc['title'],
              author: doc['author'],
              coverId: doc['coverId'],
              summary: doc['summary'],
            ),
          )
          .toList();
    } catch (e) {
      print('Error fetching saved books: $e');
      return [];
    }
  }
}
