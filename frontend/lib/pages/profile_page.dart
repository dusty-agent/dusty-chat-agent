import 'package:dusty_chat_agent/widgets/custom_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userName;
  final String userEmail;

  ProfilePage({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 계정 삭제 함수
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser?.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deleted successfully')),
      );
      Navigator.pushReplacementNamed(context, '/signup'); // 로그인 페이지로 이동
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to delete account')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      titleText: 'My Profile',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage:
                AssetImage('assets/images/dusty-person.png'), // 기본 프로필 이미지
          ),
          const SizedBox(height: 16),
          Text(
            userName, //"User Name",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Email: $userEmail",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // 로그아웃 로직 추가
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              "Log Out",
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 80),
          ElevatedButton(
            onPressed: () => deleteAccount(context),
            child: const Text(
              "Delete Account",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
