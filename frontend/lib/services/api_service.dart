import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:dusty_chat_agent/services/auth_service.dart'; // ✅ 인증 정보 사용

class ApiService {
  static final String _baseUrl =
      dotenv.get('API_BASE_URL', fallback: 'http://localhost:8000/api');

  /// ✅ **인증 헤더 추가**
  static Future<Map<String, String>> _getHeaders() async {
    String? token = await AuthService.getToken(); // ✅ 로그인된 사용자 토큰 가져오기
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  /// ✅ **공통 GET 요청 함수**
  static Future<Map<String, dynamic>> getRequest(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("❌ 요청 실패 [$endpoint]: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("❌ API 요청 실패 [$endpoint]: $e");
    }
  }

  /// ✅ **서버 상태 확인**
  static Future<String> fetchHealth() async {
    try {
      final response = await getRequest("health");
      return response["status"] ?? "알 수 없음";
    } catch (e) {
      return "❌ 서버 상태 확인 실패: $e";
    }
  }

  /// ✅ **사용 가능한 모델 목록 가져오기**
  static Future<List<String>> fetchModels() async {
    try {
      final response = await getRequest("model");
      return List<String>.from(response["models"] ?? []);
    } catch (e) {
      throw Exception("❌ 모델 정보 요청 실패: $e");
    }
  }

  /// ✅ **현재 선택된 모델명 가져오기**
  static Future<String> fetchModelName() async {
    try {
      final response = await getRequest("model");
      return response["model_name"] ?? "알 수 없음";
    } catch (e) {
      return "❌ 모델명 불러오기 실패: $e";
    }
  }

  /// ✅ **사용자 정보 가져오기**
  static Future<Map<String, dynamic>> fetchUser() async {
    try {
      final response = await getRequest("user");
      return response; // 사용자 정보 반환
    } catch (e) {
      throw Exception("❌ 사용자 정보 요청 실패: $e");
    }
  }

  /// ✅ **채팅 히스토리 가져오기**
  static Future<List<Map<String, dynamic>>> fetchChatHistory() async {
    try {
      final response = await getRequest("chat/history");
      return List<Map<String, dynamic>>.from(response["history"] ?? []);
    } catch (e) {
      throw Exception("❌ 채팅 내역 불러오기 실패: $e");
    }
  }
}
