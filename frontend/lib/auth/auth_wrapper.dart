import 'package:dusty_chat_agent/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dusty_chat_agent/pages/profile_page.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return LoginPage(); // 로그인 안됨, 로그인 페이지
          } else {
            return ProfilePage(
              userName: user.displayName ?? "User Name",
              userEmail: user.email ?? "user@example.com",
            );
          }
        } else {
          return Center(child: const CircularProgressIndicator());
        }
      },
    );
  }
}
