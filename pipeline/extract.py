import json
from sqlalchemy import create_engine, text
import os
# Chuỗi kết nối dựa trên thông tin database thực tế
DATABASE_URL = os.environ["DATABASE_URL"]

def extract_data(output_file="student_data_raw.jsonl"):
    engine = create_engine(DATABASE_URL)
    
    query = text("""
        SELECT
            l.lecturer_id,
            l.lecturer_name,
            l.email,
            l.phone_number,
            l.major_id,
            m.major_name,
            GROUP_CONCAT(
                DISTINCT r.research_name
                SEPARATOR ', '
            ) AS research_areas
        FROM Lecturer l
        JOIN Major m ON l.major_id = m.major_id
        LEFT JOIN LecturerResearch lr
            ON l.lecturer_id = lr.lecturer_id
        LEFT JOIN ResearchArea r
            ON lr.research_id = r.research_id
        GROUP BY
            l.lecturer_id,
            l.lecturer_name,
            l.email,
            l.phone_number,
            l.major_id,
            m.major_name;
    """)
    
    extracted_data = []
    with engine.connect() as conn:
        result = conn.execute(query)
        for row in result:
            # Xử lý các trường hợp số điện thoại hoặc email có thể bị trống (NULL)
            phone = row.phone_number if row.phone_number else "không có thông tin"
            email = row.email if row.email else "không có thông tin"
            major = row.major_name if row.major_name else "chưa xác định"

            research_list = (
                [area.strip() for area in row.research_areas.split(",")]
                if row.research_areas
                else []
            )
            research = ", ".join(research_list) if research_list else "chưa có thông tin"

            # Gộp thông tin thành đoạn văn bản hoàn chỉnh
            context_text = (
                f"Giảng viên {row.lecturer_name} thuộc chuyên ngành {major}. "
                f"Lĩnh vực nghiên cứu: {research}. "
                f"Email liên hệ: {email}, Số điện thoại: {phone}."
            )
            
            doc = {
                "doc_id": row.lecturer_id,
                "context_text": context_text,
                "metadata": {
                    "lecturer_name": row.lecturer_name,
                    "major_id": row.major_id,
                    "major": major,
                    "email": email,
                    "phone": phone,
                    "research_areas": research_list
                }
            }
            extracted_data.append(doc)

    with open(output_file, 'w', encoding='utf-8') as f:
        for item in extracted_data:
            f.write(json.dumps(item, ensure_ascii=False) + '\n')
            
    print(f"Đã trích xuất {len(extracted_data)} bản ghi ra {output_file}")

if __name__ == "__main__":
    extract_data()