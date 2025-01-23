# 데이터베이스 초기화 스크립트
# app/database/init_db.py

from sqlalchemy import MetaData, create_engine
from app.models.models import Base # Base와 모델을 가져옵니다.
from app.database.database import engine  # 데이터베이스 엔진을 가져옵니다.
from sqlalchemy.orm import Session
from app.models.models import Message, MessageHistory
import datetime

def init_db():
    metadata = MetaData()
    metadata.reflect(bind=engine)  # 기존 데이터베이스 메타데이터 로드
    messages_table = metadata.tables.get("messages")
    if messages_table is not None:
        messages_table.drop(engine)  # 기존 테이블 삭제
    Base.metadata.create_all(bind=engine)  # 테이블 재생성

if __name__ == "__main__":
    init_db()

def add_message(db: Session, role: str, content: str):
    # 메시지 생성
    message = Message(role=role, content=content)
    db.add(message)
    db.commit()
    db.refresh(message)
    
    # 메시지 이력 추가
    message_history = MessageHistory(
        message_id=message.id,
        role=role,
        content=content,
        created_at=datetime.datetime.utcnow()
    )
    db.add(message_history)
    db.commit()

    return message