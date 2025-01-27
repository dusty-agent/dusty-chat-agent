from sqlalchemy import MetaData
from sqlalchemy import text
from app.database.database import engine
from app.models.message import Base
from app.database.db_config import SessionLocal

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
    Base.metadata.create_all(bind=engine)
    print("데이터베이스 초기화 완료.")

def create_message(db: Session, role: str, content: str):
    """메시지 저장 및 메시지 이력 기록"""
    from app.models.message import Message, MessageHistory
    import datetime
    
    message = Message(role=role, content=content)
    db.add(message)
    db.commit()
    db.refresh(message)

    # 메시지 이력 기록
    message_history = MessageHistory(
        message_id=message.id,
        role=role,
        content=content,
        created_at=datetime.datetime.utcnow()
    )
    db.add(message_history)
    db.commit()

    return message
