import 'package:dusty_chat_agent/pages/private_policy_page.dart';
import 'package:dusty_chat_agent/pages/terms_of_service_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildFooter(BuildContext context) {
  return Container(
    color: Colors.grey[200], // Footer background color
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFooterLinks(context),
        const SizedBox(height: 8),
        GestureDetector(
          // ✅ 클릭 가능한 요소 추가
          onTap: () => _launchURL("https://draft.best"), // ✅ 링크 열기
          child: const Text(
            '© 2025 Draft Co. All rights reserved.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              decoration: TextDecoration.underline, // ✅ 밑줄 추가 (클릭 가능하다는 시각적 힌트)
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

Widget _buildFooterLinks(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _buildFooterLink(
        context,
        label: 'Privacy Policy',
        onTap: () => _navigateTo(context, const PrivacyPolicyPage()),
      ),
      const SizedBox(width: 8),
      const Text('|', style: TextStyle(fontSize: 14, color: Colors.black54)),
      const SizedBox(width: 8),
      _buildFooterLink(
        context,
        label: 'Terms of Service',
        onTap: () => _navigateTo(context, const TermsOfServicePage()),
      ),
    ],
  );
}

Widget _buildFooterLink(BuildContext context,
    {required String label, required VoidCallback onTap}) {
  return TextButton(
    onPressed: onTap,
    child: Text(
      label,
      style: const TextStyle(fontSize: 14),
    ),
  );
}

/// ✅ **웹사이트 링크 열기**
Future<void> _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "Could not launch $url";
  }
}

/// ✅ **페이지 이동**
void _navigateTo(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}
