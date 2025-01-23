from sqlalchemy import TIMESTAMP, Column, ForeignKey, Integer, String, event
from sqlalchemy.types import DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.database.database import Base
from datetime import datetime

# MessageModel 클래스는 데이터베이스와 연결되는 모델입니다.
class Message(Base):
    __tablename__ = 'messages'  # 테이블 이름
    
    id = Column(Integer, primary_key=True, index=True)
    role = Column(String, nullable=False)
    content = Column(String, nullable=False)
    created_at = Column(TIMESTAMP, default=datetime.utcnow) # 메시지 생성 시간
    
     # 기존 테이블 정의 덮어쓰기
    __table_args__ = {'extend_existing': True}
    
    #id: 메시지의 고유 ID
    #role: 사용자 또는 봇의 역할
    #content: 메시지 내용
    #created_at: 메시지가 기록된 시간 (기본값: 현재 시간)
     # history와 관계 설정
    history = relationship("MessageHistory", back_populates="message")
    
    def __repr__(self):
        return f"<MessageModel(id={self.id}, role={self.role}, content={self.content}, created_at={self.created_at})>"
    
 #Base: SQLAlchemy의 기본 모델을 설정합니다.
 #MessageModel: messages 테이블을 생성하여, id, role, content, created_at 열을 정의합니다.
 #created_at: datetime.utcnow()를 사용하여 메시지가 생성된 시간을 자동으로 저장합니다.

class MessageHistory(Base):
    __tablename__ = "messages_history"
    
    id = Column(Integer, primary_key=True, index=True)
    message_id = Column(Integer, ForeignKey('messages.id'))  # 메시지 외래 키
    role = Column(String, nullable=False)
    content = Column(String, nullable=False)
    created_at = Column(TIMESTAMP, default=datetime.utcnow)
    
    message = relationship("Message", back_populates="history")
    
@event.listens_for(Message, 'after_insert')
def log_insert(mapper, connection, target):
    # Message 테이블에 새로운 레코드가 삽입될 때마다
    message_history = MessageHistory(
        message_id=target.id,
        role=target.role,
        content=target.content,
        created_at=datetime.datetime.utcnow()
    )
    connection.execute(MessageHistory.__table__.insert(), {
        "message_id": message_history.message_id,
        "role": message_history.role,
        "content": message_history.content,
        "created_at": message_history.created_at,
    })