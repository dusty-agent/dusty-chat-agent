/* screens/chat_screen.dart */

import 'package:dusty_chat_agent/provider/gpt_provider.dart';
import 'package:dusty_chat_agent/widgets/app_bar.dart';
import 'package:dusty_chat_agent/widgets/drawer.dart';
import 'package:dusty_chat_agent/widgets/footer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/services/chat_service.dart'; // 서비스 파일을 import

class ChatScreen extends StatefulWidget {
  // final TextEditingController _controller = TextEditingController();
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();

  void sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'content': message});
      controller.clear();
    });

    try {
      final response = await ChatService.sendMessage(message); // 서비스 호출
      setState(() {
        messages.add({'role': 'assistant', 'content': response});
      });
    } catch (e) {
      // 에러 처리 (로그 출력 등)
      setState(() {
        messages.add({'role': 'assistant', 'content': 'Error: $e'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String logoPath = 'images/icon-dusty-agent.png';
    final gptProvider = Provider.of<GptProvider>(context);
    return Scaffold(
      appBar: CommonAppBar(titleText: 'AI Chatbot', logoPath: logoPath),
      drawer: CommonDrawer(),
      bottomNavigationBar: buildFooter(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 5),
          Text(
            '현재 모델: ${gptProvider.modelName}', // 모델명 표시
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(
                    message['content'] ?? '',
                    textAlign: message['role'] == 'user'
                        ? TextAlign.right
                        : TextAlign.left,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: 'Enter your message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => sendMessage(controller.text),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
