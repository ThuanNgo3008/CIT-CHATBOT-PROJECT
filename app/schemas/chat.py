from uuid import UUID

from pydantic import BaseModel, Field


class ChatRequest(BaseModel):
    query: str = Field(
        ...,
        min_length=1,
        max_length=1000,
        description="Câu hỏi của sinh viên",
    )
    session_id: UUID | None = Field(
        default=None,
        description="ID phiên chat để ghi nhớ lựa chọn giảng viên",
    )