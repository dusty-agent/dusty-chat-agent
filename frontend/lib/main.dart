import 'package:dusty_chat_agent/pages/history.dart';
import 'package:dusty_chat_agent/pages/profile_page.dart';
import 'package:dusty_chat_agent/provider/gpt_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/chat_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => GptProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: SplashScreen(),
      routes: {
        // '/': (context) => SplashScreen(),
        '/profile': (context) => ProfilePage(
            userName: "Dusty Agent", // 실제 사용자 이름
            userEmail: "soyoung@dustydraft.com"), // 실제 사용자 이메일),
        '/history': (content) => HistoryPage(),
        '/about-us': (content) => HistoryPage(),
        '/chat': (context) => ChatScreen(), // 추가
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

// 1.5초 후 메인화면이동
  _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 1500)); // 1.5초
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen()), //
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/icon-dusty-agent.png"),
      ),
    );
  }
}
