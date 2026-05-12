import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:granth/models/book_model.dart';

class BookService {
  static const String _baseUrl = 'https://openlibrary.org';

  Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search.json?q=${Uri.encodeComponent(query)}&limit=20'),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final docs = json['docs'] as List;
        return docs.map((doc) => Book.fromJson(doc)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Book>> getRecommendations() async {
    return searchBooks('classic literature');
  }

  Future<String?> getBookSummary(String bookId) async {
    try {
      final id = bookId.replaceAll('/works/', '');
      final response = await http.get(
        Uri.parse('$_baseUrl/works/$id.json'),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final description = json['description'];
        if (description is String) return description;
        if (description is Map) return description['value'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String getCoverUrl(int coverId) {
    return 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
  }
} 