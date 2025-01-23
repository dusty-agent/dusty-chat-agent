from pydantic_settings import BaseSettings 
from dotenv import load_dotenv

# .env 파일을 자동으로 로드
load_dotenv()

class Settings(BaseSettings):
    OPENAI_API_KEY: str
    DATABASE_URL: str
    app_name: str
    admin_email: str
    
    class Config:
        env_file = ".env"  # .env 파일을 읽도록 지정

settings = Settings()

# 예시로 환경 변수 사용
print(settings.OPENAI_API_KEY)
print(settings.DATABASE_URL)
print(settings.app_name)
print(settings.admin_email)