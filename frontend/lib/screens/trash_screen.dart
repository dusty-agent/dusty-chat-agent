import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dusty_chat_agent/services/chat_service.dart';

class TrashScreen extends StatefulWidget {
  @override
  _TrashScreenState createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  List<Map<String, dynamic>> deletedMessages = [];

  @override
  void initState() {
    super.initState();
    _loadDeletedMessages();
  }

  /// ✅ **삭제된 메시지 불러오기**
  void _loadDeletedMessages() async {
    try {
      final messages = await ChatService.fetchDeletedMessages();
      setState(() {
        deletedMessages = messages;
      });

      log("✅ 삭제된 메시지 불러오기 성공", level: 800);
    } catch (e) {
      log("❌ 삭제된 메시지 불러오기 실패: $e", level: 1000);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("🗑 삭제된 메시지")),
      body: deletedMessages.isEmpty
          ? Center(child: Text("삭제된 메시지가 없습니다."))
          : ListView.builder(
              itemCount: deletedMessages.length,
              itemBuilder: (context, index) {
                final message = deletedMessages[index];
                return ListTile(
                  title: Text(message["content"] ?? "내용 없음"),
                  subtitle: Text("삭제됨: ${message["deleted_at"]}"),
                  trailing: Icon(Icons.delete, color: Colors.red),
                );
              },
            ),
    );
  }
}
