import json
from sqlalchemy import create_engine, text

# Chuỗi kết nối dựa trên thông tin database thực tế
DATABASE_URL = "mysql+pymysql://cit_chatbot:201026@127.0.0.1:3308/chatbot_db?charset=utf8mb4"

def extract_data(output_file="student_data_raw.jsonl"):
    engine = create_engine(DATABASE_URL)
    
    # Query kết hợp bảng Lecturer và Major dựa trên major_id
    query = text("""
        SELECT l.lecturer_id, l.lecturer_name, l.email, l.phone_number, m.major_name 
        FROM Lecturer l 
        LEFT JOIN Major m ON l.major_id = m.major_id
    """)
    
    extracted_data = []
    with engine.connect() as conn:
        result = conn.execute(query)
        for row in result:
            # Xử lý các trường hợp số điện thoại hoặc email có thể bị trống (NULL)
            phone = row.phone_number if row.phone_number else "không có thông tin"
            email = row.email if row.email else "không có thông tin"
            major = row.major_name if row.major_name else "chưa xác định"

            # Gộp thông tin thành đoạn văn bản hoàn chỉnh
            context_text = f"Giảng viên {row.lecturer_name} thuộc chuyên ngành {major}. Email liên hệ: {email}, Số điện thoại: {phone}."
            
            doc = {
                "doc_id": row.lecturer_id,
                "context_text": context_text,
                "metadata": {
                    "lecturer_name": row.lecturer_name,
                    "major": major,
                    "email": email,
                    "phone": phone
                }
            }
            extracted_data.append(doc)

    with open(output_file, 'w', encoding='utf-8') as f:
        for item in extracted_data:
            f.write(json.dumps(item, ensure_ascii=False) + '\n')
            
    print(f"Đã trích xuất {len(extracted_data)} bản ghi ra {output_file}")

if __name__ == "__main__":
    extract_data()