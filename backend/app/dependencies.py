from sqlalchemy.orm import Session
from app.database.database import SessionLocal

def get_db():
    db: Session = SessionLocal()  # 실제로 SessionLocal 인스턴스 생성
    try:
        yield db
    finally:
        db.close()
