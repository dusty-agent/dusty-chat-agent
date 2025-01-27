# app/routers/chat.py

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.models.message import Message
from app.dependencies import get_db
from pydantic import BaseModel
from datetime import datetime
from app.database.database import SessionLocal

# Pydantic 모델 정의
class MessageCreate(BaseModel):
    role: str
    content: str

class MessageResponse(BaseModel):
    id: int
    role: str
    content: str
    created_at: datetime  # datetime 타입으로 변경

    class Config:
        orm_mode = True

router = APIRouter()

# 라우터 초기화
router = APIRouter(
    prefix="/chat",
    tags=["Chat"]
)

# 이미 app.dependencies에서 get_db가 정의되어 있다면 import하여 사용
# get_db 의존성은 이미 별도 파일에 정의되어 있으므로 중복 정의 필요 없음

@router.get("/", response_model=List[MessageResponse])
def get_messages(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    messages = db.query(Message).offset(skip).limit(limit).all()
    return messages

@router.post("/", response_model=MessageResponse)
def create_message(message: MessageCreate, db: Session = Depends(get_db)):
    new_message = Message(**message.dict())  # 메시지 데이터 삽입
    db.add(new_message)
    db.commit()
    db.refresh(new_message)
    return new_message

@router.delete("/{message_id}", response_model=dict)
def delete_message(message_id: int, db: Session = Depends(get_db)):
    message = db.query(Message).filter(Message.id == message_id).first()
    if not message:
        raise HTTPException(status_code=404, detail="Message not found")
    db.delete(message)
    db.commit()
    return {"detail": "Message deleted successfully"}
