import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _messagesKey = 'messages';
  static const String _emailKey = 'email';

  /// ✅ **로그인하지 않은 사용자의 메시지 저장**
  static Future<void> saveMessage(String message) async {
    final prefs = await SharedPreferences.getInstance();
    final currentMessages = prefs.getStringList(_messagesKey) ?? [];
    currentMessages.add(message);
    await prefs.setStringList(_messagesKey, currentMessages);
  }

  /// ✅ **저장된 메시지 가져오기**
  static Future<List<String>> getMessages() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_messagesKey) ?? [];
  }

  /// ✅ **로그인 정보 저장**
  static Future<void> saveLoginInfo(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  /// ✅ **저장된 로그인 정보 가져오기**
  static Future<String?> getLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }
}

/// ✅ **앱 내부 로그 저장 (디버깅용)**
Future<void> saveLog(String message) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/app_logs.txt');
  await file.writeAsString('$message\n', mode: FileMode.append);
}
