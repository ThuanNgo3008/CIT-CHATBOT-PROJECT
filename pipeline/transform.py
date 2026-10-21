import json
from langchain_text_splitters import RecursiveCharacterTextSplitter

def transform_to_chunks(input_file="student_data_raw.jsonl", output_file="student_data_chunked.jsonl"):
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=500,
        chunk_overlap=50,
        separators=["\n\n", "\n", ".", " ", ""]
    )
    
    processed_chunks = []
    
    with open(input_file, 'r', encoding='utf-8') as f:
        for line in f:
            data = json.loads(line.strip())
            doc_id = data["doc_id"]
            context_text = data["context_text"]
            metadata = data["metadata"]
            
            chunks = text_splitter.split_text(context_text)
            
            for idx, chunk_content in enumerate(chunks):
                chunk_doc = {
                    "parent_doc_id": doc_id,
                    "chunk_id": f"lec_{doc_id}_chunk_{idx}",
                    "content": chunk_content,
                    "metadata": metadata
                }
                processed_chunks.append(chunk_doc)
                
    with open(output_file, 'w', encoding='utf-8') as f:
        for chunk in processed_chunks:
            f.write(json.dumps(chunk, ensure_ascii=False) + '\n')
            
    print(f"Đã chia thành {len(processed_chunks)} chunks và lưu ra {output_file}")

if __name__ == "__main__":
    transform_to_chunks()