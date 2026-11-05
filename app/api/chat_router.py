import logging

from collections.abc import Iterator

from fastapi import APIRouter, HTTPException
from fastapi.responses import StreamingResponse

from app.services.rag_service import generate_answer_stream, analyze_query
from app.schemas.chat import ChatRequest

logger = logging.getLogger(__name__)

# init router
router = APIRouter()


def stream_after_first_chunk(first_chunk: str, chunks: Iterator[str]) -> Iterator[str]:
    """Send the chunk that was already read, then continue the original stream."""
    yield first_chunk
    yield from chunks


@router.post("/chat", summary="Chat với Trợ lý ảo Cố Vấn Học Tập")
def chat_with_bot(request: ChatRequest):
    """
    Endpoint nhận câu hỏi và trả về câu trả lời dạng văn bản stream.
    Hỗ trợ lọc trước theo các trường mà người dùng hỏi.
    """

    # A failed analysis only loses the filters, so the question can still be answered.
    try:
        filters = analyze_query(request.query)
    except Exception:
        logger.warning("Query analysis failed; answering without filters.")
        filters = {}

    logger.info("Phân tích câu hỏi, trích xuất được bộ lọc: %s", filters)
    answer_generator = generate_answer_stream(query=request.query, filters=filters)

    # The status code is sent with the first byte, so read the first chunk before that.
    try:
        first_chunk = next(answer_generator, "")
    except Exception as e:
        logger.error("❌ Lỗi tại endpoint /chat: %s", e)
        raise HTTPException(
            status_code=500, detail="Lỗi hệ thống nội bộ. Vui lòng thử lại sau."
        ) from e

    return StreamingResponse(
        stream_after_first_chunk(first_chunk, answer_generator),
        media_type="text/plain; charset=utf-8",
    )
