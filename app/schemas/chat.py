from pydantic import BaseModel, Field


class ChatRequest(BaseModel):
    query: str = Field(
        ...,
        min_length=1,
        max_length=1000,
        description="Câu hỏi của sinh viên",
        examples=["Có bao nhiêu giảng viên dạy trí tuệ nhân tạo?"], 
    )
