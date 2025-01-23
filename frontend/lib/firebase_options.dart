// firebase_options.dart
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Web 플랫폼에 맞는 FirebaseOptions을 리턴합니다
    if (Firebase.apps.isEmpty) {
      return FirebaseOptions(
        apiKey: 'your_api_key', // Firebase 콘솔에서 API 키를 가져옵니다
        appId: 'your_app_id', // Firebase 콘솔에서 앱 ID를 가져옵니다
        messagingSenderId: 'your_sender_id', // Firebase 콘솔에서 Sender ID를 가져옵니다
        projectId: 'your_project_id', // Firebase 콘솔에서 프로젝트 ID를 가져옵니다
        authDomain: 'your_auth_domain', // Firebase 콘솔에서 authDomain을 가져옵니다
        databaseURL: 'your_database_url', // Firebase 콘솔에서 Database URL을 가져옵니다
        storageBucket:
            'your_storage_bucket', // Firebase 콘솔에서 Storage Bucket을 가져옵니다
        measurementId:
            'your_measurement_id', // Firebase 콘솔에서 measurement ID를 가져옵니다
      );
    }
    // 추가적으로 다른 플랫폼에 대한 조건을 추가하려면, 그에 맞는 설정을 작성합니다.
    // 예: Android, iOS 등.
    throw UnsupportedError('Unsupported platform for Firebase.');
  }
}
