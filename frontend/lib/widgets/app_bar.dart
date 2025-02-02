import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText; // 타이틀 텍스트

  const CommonAppBar({
    super.key,
    required this.titleText,
  });

  @override
  Size get preferredSize => Size.fromHeight(60.0); // AppBar 높이

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 1,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
            child: Image.asset(
              'assets/images/icon-dusty-agent.png',
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
          icon: const Icon(Icons.person), // ✅ 프로필 아이콘
          tooltip: 'My Profile',
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu), // ✅ 햄버거 메뉴 아이콘
            tooltip: 'Menu',
            onPressed: () {
              Scaffold.of(context).openEndDrawer(); // ✅ 오른쪽에서 Drawer 열기
            },
          ),
        ),
      ],
    );
  }
}
