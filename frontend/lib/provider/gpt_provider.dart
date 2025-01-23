// lib/providers/gpt_provider.dart
import 'package:dusty_chat_agent/services/gpt_service.dart';
import 'package:flutter/material.dart';

class GptProvider with ChangeNotifier {
  final GptService _gptService = GptService();
  String _gptResponse = '';
  String _modelName = 'gpt-3.5-turbo'; // 모델명 추가
  bool _isLoading = false; // 로딩 상태 추가

  String get gptResponse => _gptResponse;
  String get modelName => _modelName;
  bool get isLoading => _isLoading;

  Future<void> getGptResponse(String prompt) async {
    _isLoading = true;
    notifyListeners();

    try {
      _gptResponse = await _gptService.fetchGptResponse(prompt);
    } catch (e) {
      _gptResponse = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
