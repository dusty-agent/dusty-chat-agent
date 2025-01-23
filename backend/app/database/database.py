from datetime import datetime
from sqlalchemy import TIMESTAMP, Column, Integer, String, create_engine, func #, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy.types import DateTime
# from sqlalchemy.orm import sessionmaker
# from app.core.config import settings  # DB 설정을 별도의 config에서 가져오는 방식
# 데이터베이스 URL 설정
DATABASE_URL = "postgresql://dusty_user:draft@localhost:5432/dusty_agent" #postgresql://user:password@localhost/dbname"

# 엔진 생성
engine = create_engine(DATABASE_URL, echo=True)

# 세션 생성기
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# 베이스 클래스 정의
Base = declarative_base()

class Message(Base):
    __tablename__ = "messages"
    
    id = Column(Integer, primary_key=True, index=True)
    role = Column(String, nullable=False)
    content = Column(String, nullable=False)
    created_at = Column(TIMESTAMP, default=datetime.utcnow)
    
    __table_args__ = {"extend_existing": True}  # 기존 테이블 확장

# 테이블 생성
Base.metadata.create_all(bind=engine)