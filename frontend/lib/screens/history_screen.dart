import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> messages = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMessagesByDate(DateTime.now()); // ✅ 기본적으로 오늘 날짜의 기록을 가져옴
  }

  // ✅ 날짜별 메시지 조회
  Future<void> _fetchMessagesByDate(DateTime selectedDate) async {
    String formattedDate =
        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    String url = "${dotenv.env['API_BASE_URL']}/history/date/$formattedDate";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          messages = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        throw Exception("❌ 데이터를 불러올 수 없습니다.");
      }
    } catch (e) {
      print("❌ 오류 발생: $e");
    }
  }

  // ✅ 검색 기능
  Future<void> _searchMessages(String keyword) async {
    if (keyword.isEmpty) return;
    String url =
        "${dotenv.env['API_BASE_URL']}/history/search?keyword=$keyword";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          messages = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        throw Exception("❌ 검색 결과가 없습니다.");
      }
    } catch (e) {
      print("❌ 검색 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("메시지 기록 조회")),
      body: Column(
        children: [
          // ✅ 검색 창 추가
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "메시지 검색...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchMessages(searchController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message["content"]),
                  subtitle: Text(
                    "보낸이: ${message["role"]} | ${message["created_at"]}",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
