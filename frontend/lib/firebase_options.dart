// firebase_options.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
// Import the functions you need from the SDKs you need
// import { initializeApp } from "firebase/app";
// import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Web 플랫폼에 맞는 FirebaseOptions을 리턴합니다
    if (kIsWeb) {
      return const FirebaseOptions(
          apiKey: "AIzaSyA-KJUzNnW8gtlCrndqDmezC3jtBZ0UFpc",
          authDomain: "dusty-chat-agent.firebaseapp.com",
          projectId: "dusty-chat-agent",
          storageBucket: "dusty-chat-agent.firebasestorage.app",
          messagingSenderId: "1024762240281",
          appId: "1:1024762240281:web:b9472e52e8390aaa43f988",
          measurementId: "G-JNC54BQ726");
    }
    // Initialize Firebase
    // const app = initializeApp(firebaseConfig);
    // const analytics = getAnalytics(app);
    // 추가적으로 다른 플랫폼에 대한 조건을 추가하려면, 그에 맞는 설정을 작성합니다.
    // 예: Android, iOS 등.
    throw UnsupportedError('Unsupported platform for Firebase.');
  }
}
