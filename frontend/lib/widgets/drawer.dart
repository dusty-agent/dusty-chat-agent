import 'package:flutter/material.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // DrawerHeader(
          //   decoration:
          //       BoxDecoration(color: const Color.fromARGB(255, 194, 207, 221)),
          //   child: Text(
          //     'Business',
          //     style: TextStyle(
          //         color: const Color.fromARGB(255, 20, 21, 26), fontSize: 24),
          //   ),
          // ),
          ListTile(
            // leading: Icon(Icons.home),
            title: Text(''),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          const Divider(), // 구분선
          ListTile(
            // leading: Icon(Icons.home),
            title: Text('AI chatbot'),
            onTap: () {
              Navigator.pushNamed(context, '/chat');
            },
          ),
          ListTile(
            // leading: Icon(Icons.home),
            title: Text('History'),
            onTap: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
          ListTile(
            // leading: Icon(Icons.info),
            title: Text('log in'),
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          ListTile(
            // leading: Icon(Icons.info),
            title: Text('Join us'),
            onTap: () {
              Navigator.pushNamed(context, '/signup');
            },
          ),
          const Divider(), // 구분선
          ListTile(
            // leading: Icon(Icons.info),
            title: Text('AuthWrapper Test'),
            onTap: () {
              Navigator.pushNamed(context, '/auth');
            },
          ),
          ListTile(
            // leading: Icon(Icons.info),
            title: Text('휴지통'),
            onTap: () {
              Navigator.pushNamed(context, '/trash');
            },
          ),
        ],
      ),
    );
  }
}
