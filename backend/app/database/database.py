from datetime import datetime
from sqlalchemy import TIMESTAMP, Column, Integer, String, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# 데이터베이스 URL 설정
DATABASE_URL = "postgresql://dusty_user:draft@localhost:5432/dusty_agent" 

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
    created_at = Column(TIMESTAMP(timezone=True), default=datetime.utcnow)
    
    # __table_args__가 불필요하면 제거 가능
    # __table_args__ = {"extend_existing": True}

# 테이블 생성 (현재 테이블이 이미 존재할 경우 덮어쓰지 않도록 수정)
Base.metadata.create_all(bind=engine)

# 세션 사용 예시 (DB 작업 시 세션을 사용하려면 별도로 사용)
def get_db():
    db = SessionLocal()  # DB 세션 생성
    try:
        yield db
    finally:
        db.close()  # DB 작업 후 세션 종료
