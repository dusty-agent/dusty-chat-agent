// message/message.dart

class Message {
  final String content;
  final DateTime timestamp;
  final bool isLoggedInUser; // 로그인한 사용자 여부

  Message({
    required this.content,
    required this.timestamp,
    required this.isLoggedInUser,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isLoggedInUser': isLoggedInUser,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
      isLoggedInUser: map['isLoggedInUser'],
    );
  }
}
