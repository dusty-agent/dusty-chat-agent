# database/db_config.py - DB 연결 설정

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.message import Base  # 모델 불러오기

# 데이터베이스 URL 설정
DATABASE_URL = "postgresql://user:password@dustyagent.chat/dusty_agent"  # 실제 데이터베이스 URL

# 엔진 생성 설정
engine = create_engine(DATABASE_URL)  # PostgreSQL은 connect_args 필요 없음

# 세션 생성
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# 테이블 생성
Base.metadata.create_all(bind=engine)
