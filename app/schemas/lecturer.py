from pydantic import BaseModel, Field


class LecturerUpdatePayload(BaseModel):
    lecturer_id: int = Field(
        ...,
        gt=0,
        description="ID of the lecturer to update.",
    )
    major_id: int | None = Field(default=None, gt=0)
    lecturer_name: str | None = Field(default=None, min_length=1)
    email: str | None = Field(default=None, min_length=1)
    phone_number: str | None = None
    research_areas: list[str] | None = None
