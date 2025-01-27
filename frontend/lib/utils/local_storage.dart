// utils/local_storage.dart

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // 데이터 저장 (로그인하지 않은 사용자의 메시지)
  static Future<void> saveMessage(String message) async {
    final prefs = await SharedPreferences.getInstance();
    final currentMessages = prefs.getStringList('messages') ?? [];
    currentMessages.add(message);
    await prefs.setStringList('messages', currentMessages);
  }

  // 메시지 가져오기
  static Future<List<String>> getMessages() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('messages') ?? [];
  }

  // 로그인 정보 저장
  static Future<void> saveLoginInfo(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  // 로그인 정보 가져오기
  static Future<String?> getLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }
}
