/* services/chat_service.dart */

import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  static const String _baseUrl = "http://127.0.0.1:8000"; //fastAPI 서버 URL

  static Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/chat'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'role': 'user', 'content': message}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['content'] ?? 'Sorry, I couldn\'t understand.';
    } else {
      throw Exception('Failed to connect to response');
    }
  }
}
