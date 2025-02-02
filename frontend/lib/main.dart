import 'package:dusty_chat_agent/auth/auth_wrapper.dart';
import 'package:dusty_chat_agent/auth/login_page.dart';
import 'package:dusty_chat_agent/auth/sign_up_page.dart';
import 'package:dusty_chat_agent/pages/history.dart';
import 'package:dusty_chat_agent/pages/profile_page.dart';
import 'package:dusty_chat_agent/screens/trash_screen.dart';
import 'package:dusty_chat_agent/services/api_service.dart';
import 'package:dusty_chat_agent/services/auth_service.dart';
import 'package:dusty_chat_agent/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:developer';
import 'screens/chat_screen.dart';
import 'package:logging/logging.dart';

final Logger logger = Logger('APP_LOGGER');

/// ✅ 로그 시스템 초기화
void setupLogger() {
  Logger.root.level = Level.ALL; // 모든 로그 표시
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.time}: ${record.message}');
  });
}

/// ✅ 일반 로그 (개발 환경에서만 사용)
void debugLog(String message) {
  if (dotenv.get('FLAVOR') == 'development') {
    log(message);
  }
}

/// ✅ 오류 로그 (모든 환경에서 사용)
void logError(String message, [dynamic error, StackTrace? stackTrace]) {
  logger.severe(message, error, stackTrace);
  FirebaseCrashlytics.instance.recordError(error ?? message, stackTrace);
}

/// ✅ **Firebase Crashlytics 로그 기록**
void logMessage(String message) {
  FirebaseCrashlytics.instance.log(message);
  log(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ✅ Firebase 초기화
  setupLogger();

  // 환경 변수 로드
  String envFile =
      const String.fromEnvironment('FLAVOR', defaultValue: 'development');
  await dotenv.load(fileName: ".env.$envFile");

  String apiBaseUrl =
      dotenv.get('API_BASE_URL', fallback: 'http://localhost:8000/api');
  logMessage("📡 API_BASE_URL: $apiBaseUrl");

  // 체험 계정 자동 생성
  await AuthService.ensureGuestAccount();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 86, 179, 151),
        fontFamily: 'Barlow',
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodySmall: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
      ),
      home: SplashScreen(),
      routes: {
        '/auth': (context) => AuthWrapper(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/profile': (context) => ProfilePage(
            userName: "Dusty Agent", userEmail: "soyoung@dustydraft.com"),
        '/history': (context) => HistoryPage(),
        '/chat': (context) => ChatScreen(),
        '/trash': (context) => TrashScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String serverStatus = "로딩 중...";
  String modelName = "알 수 없음";

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _initializeApp();
    });
  }

  /// ✅ **앱 초기화 - 서버 상태 및 모델 정보 확인**
  Future<void> _initializeApp() async {
    logMessage("🔄 앱 초기화 시작...");

    try {
      // 1️⃣ 모델명 가져오기
      modelName = await ApiService.fetchModelName();
      logMessage("✅ 현재 모델: $modelName");

      // 2️⃣ 로그인된 사용자 정보 가져오기
      final userInfo = await ApiService.fetchUser();
      if (userInfo.containsKey("user_name")) {
        logMessage("✅ 로그인된 사용자: ${userInfo["user_name"]}");
      } else {
        logMessage("⚠️ 로그인 필요");
      }

      // 3️⃣ 서버 상태 확인
      final healthCheck = await ApiService.fetchHealth();
      logMessage("✅ 서버 상태: $healthCheck");
    } catch (error, stackTrace) {
      logMessage("❌ 앱 초기화 중 오류 발생: $error");
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }

    logMessage("🔄 홈 화면으로 이동합니다...");
    await _navigateToHome();
  }

  /// ✅ **1.5초 후 ChatScreen으로 이동**
  Future<void> _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 1500));
    if (!mounted) return; // 위젯이 dispose 된 경우 실행 방지
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen()),
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
