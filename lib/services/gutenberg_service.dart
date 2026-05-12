import 'dart:convert';
import 'package:http/http.dart' as http;

class GutenbergService {
  static const String _baseUrl = 'https://gutendex.com';

  Future<String?> findBookUrl(String title) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/books/?search=${Uri.encodeComponent(title)}'),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final results = json['results'] as List;
        if (results.isEmpty) return null;

        final formats = results[0]['formats'] as Map<String, dynamic>;
        for (final key in formats.keys) {
          if (key.contains('text/plain')) {
            return formats[key] as String;
          }
        }
      }
      return null;
    } catch (e) {
      print('Error finding book: $e');
      return null;
    }
  }

  Future<String?> fetchBookText(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) return response.body;
      return null;
    } catch (e) {
      print('Error fetching text: $e');
      return null;
    }
  }
}