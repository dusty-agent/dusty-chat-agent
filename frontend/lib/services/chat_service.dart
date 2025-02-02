import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:dusty_chat_agent/services/auth_service.dart';
import 'package:dusty_chat_agent/services/api_service.dart';

class ChatService {
  static final String _baseUrl =
      dotenv.get('API_BASE_URL', fallback: 'http://localhost:8000/api');

  // ✅ 사용자 인증 헤더 추가 (비동기 처리)
  static Future<Map<String, String>> _getHeaders() async {
    String? token = await AuthService.getToken();
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  /// ✅ **메시지 보내기 (로그인된 사용자)**
  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/chat"),
        headers: await _getHeaders(),
        body: jsonEncode({"content": message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["response"] ?? "응답 없음";
      } else {
        throw Exception("서버 오류: ${response.statusCode}");
      }
    } catch (e) {
      return "오류 발생: $e";
    }
  }

  /// ✅ **로그인한 사용자의 채팅 내역 불러오기**
  static Future<List<Map<String, dynamic>>> fetchChatHistory() async {
    return await ApiService.fetchChatHistory(); // ✅ 공통 API 사용
  }

  /// ✅ **삭제된 메시지(휴지통) 조회**
  static Future<List<Map<String, dynamic>>> fetchDeletedMessages() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/chat/deleted"),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception("❌ 삭제된 메시지 불러오기 실패: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("❌ API 요청 실패: $e");
    }
  }
}
