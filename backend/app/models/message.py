from sqlalchemy import TIMESTAMP, Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
from sqlalchemy import event

# Base: SQLAlchemy의 기본 모델을 설정합니다.
Base = declarative_base()

class Message(Base):
    __tablename__ = 'messages'  # 테이블 이름
    
    id = Column(Integer, primary_key=True, index=True)
    role = Column(String, nullable=False)
    content = Column(String, nullable=False)
    created_at = Column(TIMESTAMP, default=datetime.utcnow) # 메시지 생성 시간
    
    # history와 관계 설정
    history = relationship("MessageHistory", back_populates="message")
    
    def __repr__(self):
        return f"<Message(id={self.id}, role={self.role}, content={self.content}, created_at={self.created_at})>"

class MessageHistory(Base):
    __tablename__ = "messages_history"
    
    id = Column(Integer, primary_key=True, index=True)
    message_id = Column(Integer, ForeignKey('messages.id'))  # 메시지 외래 키
    role = Column(String, nullable=False)
    content = Column(String, nullable=False)
    created_at = Column(TIMESTAMP, default=datetime.utcnow)
    
    message = relationship("Message", back_populates="history")

# 메시지가 삽입될 때마다 MessageHistory에 해당 메시지를 기록
@event.listens_for(Message, 'after_insert')
def log_insert(mapper, connection, target):
    """Message 테이블에 새로운 레코드가 삽입될 때마다 MessageHistory에 기록"""
    message_history = MessageHistory(
        message_id=target.id,
        role=target.role,
        content=target.content,
        created_at=datetime.utcnow()
    )
    connection.execute(MessageHistory.__table__.insert(), {
        "message_id": message_history.message_id,
        "role": message_history.role,
        "content": message_history.content,
        "created_at": message_history.created_at,
    })
