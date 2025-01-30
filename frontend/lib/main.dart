import 'package:dusty_chat_agent/auth/auth_wrapper.dart';
import 'package:dusty_chat_agent/auth/login_page.dart';
import 'package:dusty_chat_agent/auth/sign_up_page.dart';
import 'package:dusty_chat_agent/pages/history.dart';
import 'package:dusty_chat_agent/pages/profile_page.dart';
import 'package:dusty_chat_agent/provider/gpt_provider.dart';
import 'package:dusty_chat_agent/services/chat_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'screens/chat_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the platform-specific options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (kDebugMode) {
      print('Firebase initialization error: $e');
    }
  }
  await dotenv.load(); // 환경 변수 로드
  String apiKey = dotenv.env['OPENAI_API_KEY'] ?? 'default_key';
  // Now run your app
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
        primaryColor: Color.fromARGB(255, 86, 179, 151), // 기본 색상
        fontFamily: 'Barlow', // Barlow 폰트를 전역으로 적용
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16), // 기본 본문 텍스트 스타일
          bodyMedium: TextStyle(fontSize: 14), // 작은 본문 텍스트 스타일
          displayLarge: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold), // 큰 제목 텍스트 스타일
          titleLarge: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold), // 중간 제목 텍스트 스타일
          bodySmall:
              TextStyle(fontSize: 12, fontStyle: FontStyle.italic), // 캡션 스타일
        ),
      ),
      home: SplashScreen(),
      routes: {
        // '/splash': (context) => SplashScreen(),
        '/auth': (context) => AuthWrapper(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/profile': (context) => ProfilePage(
            userName: "Dusty Agent", // 실제 사용자 이름
            userEmail: "soyoung@dustydraft.com"), // 실제 사용자 이메일),
        '/history': (content) => HistoryPage(),
        '/chat': (context) => ChatScreen(), // 추가
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  // 데이터를 가져오는 함수
  _initializeApp() async {
    try {
      // 데이터를 가져오는 API 호출
      await ChatService.fetchData(); // 실제 API 호출 (예시로 ChatService 사용)

      // 데이터 로딩 후 ChatScreen으로 이동
      _navigateToHome();
    } catch (error) {
      // 에러 처리
      if (kDebugMode) {
        print("Failed to fetch data: $error");
      }
      _navigateToHome(); // 실패해도 홈으로 이동
    }
  }

  // 1.5초 후 ChatScreen으로 이동
  _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 1500)); // 1.5초
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen()), // ChatScreen으로 이동
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
