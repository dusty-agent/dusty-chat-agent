import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyA-KJUzNnW8gtlCrndqDmezC3jtBZ0UFpc",
      authDomain: "dusty-chat-agent.firebaseapp.com",
      projectId: "dusty-chat-agent",
      storageBucket: "dusty-chat-agent.appspot.com",
      messagingSenderId: "1024762240281",
      appId: "1:1024762240281:web:b9472e52e8390aaa43f988",
      measurementId: "G-JNC54BQ726",
    );
  }
}
