/* widgets/chat_message_widget.dart */

import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  final String content;
  final String role;

  const ChatMessageWidget({required this.content, required this.role});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        content,
        textAlign: role == 'user' ? TextAlign.right : TextAlign.left,
        style: TextStyle(
          color: role == 'user' ? Colors.blue : Colors.green, // 색상 구분
          //background:
        ),
      ),
    );
  }
}
