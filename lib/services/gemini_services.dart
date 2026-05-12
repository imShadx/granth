import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  Future<String?> sendMessage(
    List<Map<String, String>> history,
    String message,
  ) async {
    try {
      // Build conversation history for context
      final contents = [
        ...history.map(
          (msg) => {
            'role': msg['role'],
            'parts': [
              {'text': msg['content']},
            ],
          },
        ),
        {
          'role': 'user',
          'parts': [
            {'text': message},
          ],
        },
      ];

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': contents,
          'systemInstruction': {
            'parts': [
              {
                'text':
                    'You are a helpful book assistant for an app called Granth. Help users find books, give recommendations, summarize books, and discuss literature. Keep responses concise and conversational.',
              },
            ],
          },
        }),
      );
      print(
        'API key: ${_apiKey.isEmpty ? "EMPTY" : "loaded (${_apiKey.length} chars)"}',
      );
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['candidates'][0]['content']['parts'][0]['text'];
      }
      return null;
    } catch (e) {
      print('Gemini error: $e');
      return null;
    }
  }
}
