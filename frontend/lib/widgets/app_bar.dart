import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String logoPath; // 특정 페이지에 따라 이미지 경로
  final String titleText; // 타이틀 텍스트

  const CommonAppBar({
    super.key,
    required this.logoPath,
    required this.titleText,
  });

  @override
  Size get preferredSize => Size.fromHeight(60.0); // AppBar 높이

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, //transparent,
      elevation: 1,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
            child: Image.asset(
              logoPath, // 이미지 경로
              height: 32,
            ),
          ),
          const SizedBox(width: 8),
          Text(titleText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ))
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.person), // 다국어 버튼
          tooltip: 'My Profile',
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ],
    );
  }
}
