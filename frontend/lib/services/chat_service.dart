import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  static final String _baseUrl =
      dotenv.get('API_BASE_URL', fallback: 'http://dustyagent.chat');

  // 메시지를 서버로 보내는 함수
  static Future<String> sendMessage(String message) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/chat'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'role': 'user', 'content': message}),
          )
          .timeout(Duration(seconds: 10)); // 타임아웃 설정

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['content'] ?? 'Sorry, I couldn\'t understand.';
      } else {
        throw Exception(
            'Failed to connect to response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  // 데이터를 서버에서 가져오는 함수
  static Future<String> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/data'))
          .timeout(Duration(seconds: 10)); // 타임아웃 설정

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['data'] ?? 'No data found.';
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }
}
