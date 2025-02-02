import 'package:flutter/material.dart';
import 'package:dusty_chat_agent/auth/login_page.dart';
import 'package:dusty_chat_agent/pages/profile_page.dart';
import 'package:dusty_chat_agent/services/auth_service.dart';

// AuthService 기반 로그인 여부 확인
// 로그인 여부에 따라 ProfilePage 또는 LoginPage로 전환
class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isLoggedIn = false;
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  /// ✅ **로그인 상태 확인 (JWT 토큰 기반)**
  void _checkAuthStatus() async {
    bool loggedIn = await AuthService.isLoggedIn();
    if (loggedIn) {
      String? userId = await AuthService.getUserId();
      setState(() {
        _isLoggedIn = true;
        _isLoading = false;
        _userName = "User $userId"; // 🚀 실제 API 호출로 사용자 정보 불러오기 필요
        _userEmail = "$userId@example.com"; // 🚀 실제 사용자 이메일 불러오기 필요
      });
    } else {
      setState(() {
        _isLoading = false;
        _isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return _isLoggedIn
        ? ProfilePage(
            userName: _userName ?? "User",
            userEmail: _userEmail ?? "user@example.com")
        : LoginPage();
  }
}
