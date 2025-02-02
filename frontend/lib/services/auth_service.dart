import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final _storage = FlutterSecureStorage();
  static const String _tokenKey = "auth_token";
  static const String _userIdKey = "user_id";
  static final String _baseUrl =
      dotenv.get('API_BASE_URL', fallback: 'http://localhost:8000/api');

  /// ✅ **JWT 토큰 & 사용자 ID를 동시에 저장**
  static Future<void> saveAuthData(String token, String userId) async {
    await Future.wait([
      _storage.write(key: _tokenKey, value: token),
      _storage.write(key: _userIdKey, value: userId),
    ]);
  }

  /// ✅ **JWT 토큰 가져오기**
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// ✅ **사용자 ID 가져오기**
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// ✅ **로그아웃**
  static Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
  }

  /// ✅ **회원가입 요청**
  static Future<bool> signUp(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception("❌ 회원가입 실패: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("❌ 회원가입 오류: $e");
    }
  }

  /// ✅ **로그인 요청**
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveAuthData(data["token"], data["user_id"]); // ✅ 동시에 저장
        return true;
      } else {
        throw Exception("❌ 로그인 실패: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("❌ 로그인 오류: $e");
    }
  }

  /// ✅ **사용자가 로그인되어 있는지 확인**
  static Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null;
  }

  /// ✅ **체험 계정 자동 생성 (게스트 로그인)**
  static Future<void> ensureGuestAccount() async {
    bool loggedIn = await isLoggedIn();
    if (!loggedIn) {
      final response = await http.post(Uri.parse("$_baseUrl/auth/guest"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveAuthData(data["token"], data["user_id"]); // ✅ 동시에 저장
      } else {
        throw Exception("체험 계정 생성 실패: ${response.statusCode}");
      }
    }
  }
}
