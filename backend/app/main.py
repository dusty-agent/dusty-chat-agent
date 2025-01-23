# app/main.py

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import MetaData
from app.routers.chat import router  # chat router 가져오기
from app.database.database import engine, Base 
from app.models.models import Message
from app.dependencies import get_db 

# 애플리케이션 초기화
app = FastAPI()

# 데이터베이스 초기화
def init_db():
    metadata = MetaData()
    metadata.reflect(bind=engine)
    messages_table = metadata.tables.get("messages")
    if messages_table is not None:
        messages_table.drop(engine)
    Base.metadata.create_all(engine)

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

@app.get("/")
async def read_root():
    return {"message": "API is running"}

# router 등록
app.include_router(router) # chat 라우터를 등록하여 /chat 경로 처리가 가능하게 합니다.


