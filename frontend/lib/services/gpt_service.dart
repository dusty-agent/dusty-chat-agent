// lib/services/gpt_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class GptService {
  final String apiUrl = 'https://api.openai.com/v1/completions';
  final String apiKey = 'sk-...7ibM'; // 'YOUR_API_KEY';

  Future<String> fetchGptResponse(String prompt) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo', //'text-davinci-003',
        'prompt': prompt,
        'max_tokens': 150,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['text'];
    } else {
      throw Exception('Failed to load GPT response');
    }
  }
}
