# dusty_chat_agent

A new Flutter & FastAPI project.

## Getting Started

for using the Flutter
This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

for using the FastApi
https://fastapi.tiangolo.com/ko/tutorial/first-steps/#api_1

## Directory Architecture

project-root/
│
├── frontend/            # Flutter 프로젝트 디렉토리
│   ├── lib/             # Flutter 소스 코드
│   │   ├── main.dart    # Flutter 진입점
│   │   ├── screens/     # 화면 구성
│   │   ├── widgets/     # 재사용 가능한 위젯
│   │   └── services/    # API 통신 파일
│   └── pubspec.yaml     # Flutter 종속성 파일
│
├── backend/             # FastAPI 백엔드 디렉토리
│   ├── app/             # FastAPI 앱 모듈
│   │   ├── main.py      # FastAPI 진입점
│   │   ├── routers/     # API 라우터
│   │   ├── models/      # Pydantic 모델
│   │   └── database.py  # 데이터베이스 설정 파일
│   ├── requirements.txt # Python 종속성 파일
│   └── .env             # API 키 및 환경 변수
│
└── README.md            # 프로젝트 설명 파일


flutter_project/
├── lib/
│   ├── main.dart                # 앱의 진입점
│   ├── services/
│   │   ├── chat_service.dart    # 채팅 관련 서비스 (메시지 저장 및 전송)
│   │   └── gpt_service.dart     # GPT 연동 관련 서비스
│   ├── screens/
│   │   ├── home_screen.dart     # 홈 화면
│   │   └── login_screen.dart    # 로그인 화면
│   ├── models/
│   │   └── message.dart         # 메시지 모델 (예: message_id, content 등)
│   └── utils/
│       └── local_storage.dart   # 로컬 저장소 관련 코드 (SharedPreferences)
├── pubspec.yaml                 # 의존성 파일
└── android/                     # Android 앱 관련 디렉토리
└── ios/                         # iOS 앱 관련 디렉토리