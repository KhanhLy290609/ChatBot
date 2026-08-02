# Design Spec: ChatBot Tư Vấn Hướng Nghiệp THPT (EduPath AI)

**Ngày khởi tạo:** 2026-08-02  
**Vị trí dự án:** `d:\ChatBot`  
**Mục tiêu:** Xây dựng ứng dụng Web Chatbot tư vấn hướng nghiệp chọn ngành đại học cho học sinh THPT tại Việt Nam (sử dụng Gemini API), giao diện hiện đại và deploy công khai lên GitHub Pages.

---

## 1. Yêu Cầu Tính Năng Cốt Lõi

1. **Bot trò chuyện tiếng Việt (Gemini API)**:
   - System Prompt thiết kế chuyên biệt làm "Chuyên gia Tư vấn Hướng nghiệp THPT Việt Nam".
   - Phân tích khối thi (A00, A01, B00, C00, D01, D07...), ngành học, điểm chuẩn tham khảo, cơ hội việc làm & trường Đại học uy tín.
   - Hỗ trợ câu hỏi mẫu (Quick Prompts) và định dạng tin nhắn Markdown (bullet, in đậm, bảng).

2. **Quản lý Gemini API Key An Toàn (Client-side)**:
   - Modal Settings cho phép học sinh/người dùng tự nhập API Key cá nhân.
   - Nút 1-click dẫn tới Google AI Studio lấy Key miễn phí.
   - Lưu trữ an toàn trong LocalStorage.

3. **Bộ Trắc Nghiệm Hướng Nghiệp Holland (Holland Quiz)**:
   - 6 câu hỏi khảo sát ngắn phân tích 6 nhóm tính cách (R-I-A-S-E-C).
   - Đưa ra đánh giá sơ bộ và nút bấm "Chuyển kết quả sang Chatbot để AI tư vấn chuyên sâu".

4. **Danh Mục Tra Cứu Ngành Hot (Career Explorer)**:
   - Thẻ hiển thị các nhóm ngành phổ biến tại Việt Nam (CNTT, Kinh Tế, Y Dược, AI, Marketing, Design...).
   - Lọc theo khối thi và bấm vào thẻ để gửi câu hỏi trực tiếp cho AI.

5. **Deploy Công Khai (GitHub Pages)**:
   - Cấu hình `vite.config.js` tương thích với tĩnh.
   - File GitHub Actions `.github/workflows/deploy.yml` tự động build & deploy.

---

## 2. Công Nghệ & Kiến Trúc

- **Frontend**: React 18, Vite.
- **Styling**: Vanilla CSS3 với CSS Variables (Indigo, Violet, Emerald palette), Glassmorphism, Dark/Light Mode.
- **Icons**: Lucide React.
- **API Call**: Google AI REST API (`gemini-1.5-flash`).
- **Deploy**: GitHub Pages via GitHub Actions.
