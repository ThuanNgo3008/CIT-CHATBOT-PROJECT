from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

import logging
import os

from app.api.chat_router import router as chat_router

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)

logger = logging.getLogger(__name__)

app = FastAPI(
    title="CIT CHATBOT",
    description="Academic advising support chatbot",
    version="1.0.0",
)

allowed_origins = [
    origin.strip()
    for origin in os.getenv("CORS_ALLOWED_ORIGINS", "").split(",")
    if origin.strip()
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_methods=["GET", "POST"],
    allow_headers=["Content-Type"],
)

app.include_router(chat_router, prefix="/api")


@app.get("/")
def test():
    return {"status": "online", "message": "Welcome to my chatbot"}


logger.info("Run server FastAPI")
