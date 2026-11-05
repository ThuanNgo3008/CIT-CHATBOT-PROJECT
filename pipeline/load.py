import json
import os
import uuid
from dotenv import load_dotenv
from openai import OpenAI
from qdrant_client import QdrantClient
from qdrant_client.http import models

# dòng này để yêu cầu Python đọc file .env
load_dotenv()

# Lúc này os.getenv mới lấy được key
openai_client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
QDRANT_URL = os.getenv("QDRANT_URL", "http://localhost:6333")
qdrant_client = QdrantClient(url=QDRANT_URL, api_key=os.getenv("QDRANT_API_KEY"))

COLLECTION_NAME = "cit_chatbot_collection"
EMBEDDING_MODEL = "text-embedding-3-small"
BATCH_SIZE = 100

# Payload fields filtered by app/services/rag_service.py.
PAYLOAD_INDEXES = {
    "research_areas": models.PayloadSchemaType.KEYWORD,
    "major": models.PayloadSchemaType.KEYWORD,
    "lecturer_name": models.PayloadSchemaType.KEYWORD,
    "email": models.PayloadSchemaType.KEYWORD,
    "phone": models.PayloadSchemaType.KEYWORD,
    "major_id": models.PayloadSchemaType.INTEGER,
    "parent_doc_id": models.PayloadSchemaType.INTEGER,
}


def setup_qdrant():
    collections = [col.name for col in qdrant_client.get_collections().collections]
    if COLLECTION_NAME not in collections:
        qdrant_client.create_collection(
            collection_name=COLLECTION_NAME,
            vectors_config=models.VectorParams(
                size=1536, distance=models.Distance.COSINE
            ),
        )
        print(f"Đã tạo collection {COLLECTION_NAME}")

    # Runs on existing collections too; re-creating an index is harmless.
    for field_name, field_schema in PAYLOAD_INDEXES.items():
        qdrant_client.create_payload_index(
            collection_name=COLLECTION_NAME,
            field_name=field_name,
            field_schema=field_schema,
        )


def get_embeddings(texts):
    response = openai_client.embeddings.create(input=texts, model=EMBEDDING_MODEL)
    # Results carry an index, so restore the input order explicitly.
    ordered_items = sorted(response.data, key=lambda item: item.index)
    return [item.embedding for item in ordered_items]


def load_data_to_qdrant(input_file="student_data_chunked.jsonl"):
    with open(input_file, "r", encoding="utf-8") as f:
        chunks = [json.loads(line) for line in f if line.strip()]

    for start in range(0, len(chunks), BATCH_SIZE):
        batch = chunks[start : start + BATCH_SIZE]
        vectors = get_embeddings([data["content"] for data in batch])
        points = []

        for data, vector in zip(batch, vectors, strict=True):
            payload = {
                "parent_doc_id": data["parent_doc_id"],
                "content": data["content"],
                **data["metadata"],
            }

            point_id = str(uuid.uuid5(uuid.NAMESPACE_DNS, data["chunk_id"]))
            points.append(
                models.PointStruct(id=point_id, vector=vector, payload=payload)
            )

        qdrant_client.upsert(collection_name=COLLECTION_NAME, points=points)
        print(f"Đã nạp {len(points)} vectors vào Qdrant...")


if __name__ == "__main__":
    setup_qdrant()
    load_data_to_qdrant()
