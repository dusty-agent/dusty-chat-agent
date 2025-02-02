import 'dart:developer';
import 'package:dusty_chat_agent/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:dusty_chat_agent/services/chat_service.dart';
import 'package:dusty_chat_agent/auth/login_page.dart';
import 'package:dusty_chat_agent/auth/sign_up_page.dart';
import 'package:dusty_chat_agent/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();
  bool isLoggedIn = false; // ✅ 로그인 상태 체크
  int messageCount = 10; // ✅ 로그인하지 않은 경우 제한 메시지 개수
  bool _isGuest = true; // 로그인 상태에 따라 변경

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _checkAndShowDialog();
  }

  /// ✅ **로그인 상태 확인**
  void _checkLoginStatus() async {
    bool loggedIn = await AuthService.isLoggedIn();
    setState(() {
      isLoggedIn = loggedIn;
    });

    if (!loggedIn) {
      _showWelcomeDialog();
    } else {
      _loadChatHistory();
    }
  }

  // ✅ 사용자가 팝업을 이미 봤는지 확인하고, 처음이라면 보여줌
  Future<void> _checkAndShowDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenPopup = prefs.getBool('hasSeenPopup') ?? false;

    if (!hasSeenPopup) {
      _showWelcomeDialog();
      await prefs.setBool('hasSeenPopup', true);
    }
  }

  // ✅ 환영 팝업 메시지 표시
  void _showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_isGuest ? "체험 계정 안내" : "환영합니다!"),
          content: Text(_isGuest
              ? "현재 체험 계정으로 로그인 중입니다. 일부 기능이 제한될 수 있습니다."
              : "정식 회원으로 로그인하셨습니다. 모든 기능을 이용할 수 있습니다."),
          actions: [
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// ✅ **채팅 내역 불러오기 (로그인한 경우)**
  void _loadChatHistory() async {
    try {
      final chatHistory = await ChatService.fetchChatHistory();
      setState(() {
        messages.addAll(chatHistory.map((msg) => {
              "role": msg["role"] ?? "unknown",
              "content": msg["content"] ?? "내용 없음",
            }));
      });

      log("✅ 채팅 내역 불러오기 성공", level: 800);
    } catch (e) {
      log("❌ 채팅 내역 불러오기 실패: $e", level: 1000);
    }
  }

  /// ✅ **메시지 전송 (로그인 안 한 경우 제한)**
  void sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    if (!isLoggedIn && messageCount >= 3) {
      setState(() {
        messages.add({
          "role": "assistant",
          "content": "🚨 더 많은 대화를 하려면 로그인해주세요!",
        });
      });
      return;
    }

    setState(() {
      messages.add({"role": "user", "content": message});
      controller.clear();
    });

    try {
      final response = await ChatService.sendMessage(message);
      setState(() {
        messages.add({"role": "assistant", "content": response});
      });

      log("✅ 메시지 전송 성공: $message", level: 800);
      messageCount++; // ✅ 메시지 개수 증가
    } catch (e) {
      setState(() {
        messages.add({"role": "assistant", "content": "❌ 오류 발생: $e"});
      });
      log("❌ 메시지 전송 오류: $e", level: 1000);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      titleText: 'Dusty Chat Agent',
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length + (!isLoggedIn ? 1 : 0), // ✅ 버튼 포함
              itemBuilder: (context, index) {
                if (!isLoggedIn && index == messages.length) {
                  return _buildWelcomeOptions();
                }
                final message = messages[index];
                return ListTile(
                  title: Text(
                    message["content"]!,
                    textAlign: message["role"] == "user"
                        ? TextAlign.right
                        : TextAlign.left,
                  ),
                );
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  /// ✅ **로그인/회원가입 버튼 추가**
  Widget _buildWelcomeOptions() {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          "🎉 계속하려면 선택해주세요!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: const Text("🔑 로그인하기"),
        ),
        const SizedBox(height: 5),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUpPage()));
          },
          child: const Text("📝 회원가입하기"),
        ),
        const SizedBox(height: 5),
        TextButton(
          onPressed: () {
            setState(() {
              messages.add({
                "role": "assistant",
                "content": "🗨️ 로그인 없이 AI와 대화할 수 있어요! (제한 있음)",
              });
            });
          },
          child: const Text("🚀 로그인 없이 체험하기"),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ✅ **입력 필드**
  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
                controller: controller,
                decoration:
                    const InputDecoration(hintText: 'Enter your message')),
          ),
          IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => sendMessage(controller.text)),
        ],
      ),
    );
  }
}
