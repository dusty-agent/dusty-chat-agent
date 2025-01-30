# app/main.py

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import MetaData
from sqlalchemy import text
from app.routers.chat import router  # chat router 가져오기
from app.database.database import engine, Base 
from app.models.message import Message
from app.dependencies import get_db 

# 애플리케이션 초기화
app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "API is running"}


def init_db():
    """데이터베이스 초기화 및 테이블 재생성"""
    metadata = MetaData()
    metadata.reflect(bind=engine)  # 기존 메타데이터 로드

    # 기존 테이블 삭제
    messages_table = metadata.tables.get("messages")
    if messages_table is not None:
        # 엔진에서 커넥션을 얻어 DROP TABLE 실행
        with engine.connect() as connection:
            connection.execute(text('DROP TABLE IF EXISTS messages CASCADE'))
        # # CASCADE를 사용하여 의존성 있는 객체들도 삭제
        # engine.execute('DROP TABLE IF EXISTS messages CASCADE')
        # # messages_table.drop(engine, checkfirst=True, cascade=True)

    # 테이블 생성
    Base.metadata.create_all(engine)
    print("데이터베이스 초기화 완료.")

@app.on_event("startup")
async def startup_event():
    init_db()  # 앱 시작 시 데이터베이스 초기화

# 테이블 생성 (DB 초기화)
Base.metadata.create_all(bind=engine)

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 모든 도메인에서 접근 허용
    allow_credentials=True,
    allow_methods=["*"],  # 모든 HTTP 메서드 허용
    allow_headers=["*"],  # 모든 헤더 허용
)


# router 등록
app.include_router(router) # chat 라우터를 등록하여 /chat 경로 처리가 가능하게 합니다.


