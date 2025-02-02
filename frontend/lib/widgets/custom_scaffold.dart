import 'package:flutter/material.dart';
import 'package:dusty_chat_agent/widgets/app_bar.dart';
import 'package:dusty_chat_agent/widgets/drawer.dart';
import 'package:dusty_chat_agent/widgets/footer.dart';

class CustomScaffold extends StatelessWidget {
  final String titleText;
  final Widget body;

  const CustomScaffold({
    Key? key,
    required this.titleText,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(titleText: titleText), //'Dusty Chat Agent'),
      endDrawer: const CommonDrawer(), // ✅ Drawer 추가
      body: body,
      bottomNavigationBar: buildFooter(context),
    );
  }
}
