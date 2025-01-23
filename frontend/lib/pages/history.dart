import 'package:dusty_chat_agent/widgets/app_bar.dart';
import 'package:dusty_chat_agent/widgets/drawer.dart';
import 'package:dusty_chat_agent/widgets/footer.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<Map<String, String>> chatHistory = [
    // 히스토리 데이터 예시
    {"title": "Chat with GPT", "date": "2025-01-22"},
    {"title": "Product Recommendation", "date": "2025-01-21"},
    {"title": "Support Inquiry", "date": "2025-01-20"},
  ];

  @override
  Widget build(BuildContext context) {
    String logoPath = 'images/icon-dusty-agent.png';
    return Scaffold(
      appBar: CommonAppBar(titleText: 'AI Chatbot', logoPath: logoPath),
      drawer: CommonDrawer(),
      bottomNavigationBar: buildFooter(context),
      body: chatHistory.isEmpty
          ? Center(
              child: Text(
                "No history available.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                final history = chatHistory[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    title: Text(history["title"]!),
                    subtitle: Text(history["date"]!),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // 히스토리 상세 보기 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryDetailPage(
                            title: history["title"]!,
                            date: history["date"]!,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class HistoryDetailPage extends StatelessWidget {
  final String title;
  final String date;

  const HistoryDetailPage({
    super.key,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title: $title",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Date: $date",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              "This is a detailed view of the chat history. You can display the full conversation here or any other relevant details.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
