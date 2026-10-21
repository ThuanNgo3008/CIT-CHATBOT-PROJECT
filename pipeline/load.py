import json
import os
import uuid
from dotenv import load_dotenv  # Thêm dòng này để import thư viện
from openai import OpenAI
from qdrant_client import QdrantClient
from qdrant_client.http import models

# Thêm dòng này để yêu cầu Python đọc file .env
load_dotenv()

# Lúc này os.getenv mới lấy được key
openai_client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
qdrant_client = QdrantClient(host="localhost", port=6333)

COLLECTION_NAME = "cit_chatbot_collection"

def setup_qdrant():
    collections = [col.name for col in qdrant_client.get_collections().collections]
    if COLLECTION_NAME not in collections:
        qdrant_client.create_collection(
            collection_name=COLLECTION_NAME,
            vectors_config=models.VectorParams(size=1536, distance=models.Distance.COSINE),
        )
        qdrant_client.create_payload_index(
            collection_name=COLLECTION_NAME,
            field_name="department",
            field_schema=models.PayloadSchemaType.KEYWORD,
        )
        print(f"Đã tạo collection {COLLECTION_NAME}")

def get_embedding(text):
    response = openai_client.embeddings.create(
        input=text,
        model="text-embedding-3-small"
    )
    return response.data[0].embedding

def load_data_to_qdrant(input_file="student_data_chunked.jsonl"):
    points = []
    batch_size = 100
    
    with open(input_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    for index, line in enumerate(lines):
        data = json.loads(line.strip())
        vector = get_embedding(data["content"])
        
        payload = {
            "parent_doc_id": data["parent_doc_id"],
            "content": data["content"],
            **data["metadata"]
        }
        
        point_id = str(uuid.uuid5(uuid.NAMESPACE_DNS, data["chunk_id"]))
        points.append(models.PointStruct(id=point_id, vector=vector, payload=payload))
        
        if len(points) >= batch_size or index == len(lines) - 1:
            qdrant_client.upsert(
                collection_name=COLLECTION_NAME,
                points=points
            )
            print(f"Đã nạp {len(points)} vectors vào Qdrant...")
            points = []

if __name__ == "__main__":
    setup_qdrant()
    load_data_to_qdrant()