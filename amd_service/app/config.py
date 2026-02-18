from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    log_level: str = "info"
    workers: int = 4

    class Config:
        env_file = ".env"


settings = Settings()
