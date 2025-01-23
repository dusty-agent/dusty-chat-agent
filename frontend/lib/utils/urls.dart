import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url, BuildContext context) async {
  try {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await _showError(context, '링크를 열 수 없습니다.');
    }
  } catch (e) {
    await _showError(context, '예상치 못한 오류가 발생했습니다.');
  }
}

Future<void> _showError(BuildContext context, String message) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
