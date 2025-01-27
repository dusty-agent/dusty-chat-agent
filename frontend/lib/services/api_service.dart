import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static final String _baseUrl =
      dotenv.get('API_BASE_URL', fallback: 'http://dustyagent.chat');

  // 데이터를 서버에서 가져오는 함수
  Future<String> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/chat'))
          .timeout(Duration(seconds: 10)); // 타임아웃 설정

      if (response.statusCode == 200) {
        return response.body; // 정상적인 응답
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }
}
