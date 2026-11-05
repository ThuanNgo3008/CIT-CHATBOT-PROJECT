from pydantic import BaseModel, Field
from typing import Optional


class ChatRequest(BaseModel):
    query: str = Field(
        ...,
        min_length=1,
        description="Câu hỏi của sinh viên",
        examples=["Giảng viên nào nghiên cứu trí tuệ nhân tạo"],
    )
