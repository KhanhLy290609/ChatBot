# 🎓 EduPath AI - Chatbot Tư Vấn Hướng Nghiệp THPT

Ứng dụng web Chatbot AI tư vấn chọn ngành Đại học, tư vấn khối thi và định hướng nghề nghiệp dành riêng cho học sinh THPT tại Việt Nam.

![EduPath AI](https://img.shields.io/badge/Status-Ready-emerald) ![React](https://img.shields.io/badge/React-18-blue) ![Vite](https://img.shields.io/badge/Vite-6-purple) ![Gemini API](https://img.shields.io/badge/Gemini-1.5--Flash-indigo)

---

## 🌟 Tính Năng Nổi Bật

1. **Chatbot Tư Vấn Chuyên Sâu (Gemini 1.5 Flash)**:
   - System Prompt thiết kế chuẩn mực về tuyển sinh Đại học và giáo dục THPT tại Việt Nam.
   - Giải đáp khối thi (A00, A01, B00, C00, D01, D07...), điểm chuẩn tham khảo, các trường uy tín và lộ trình ôn thi.
   - Thanh gợi ý câu hỏi nhanh (Quick Prompts) và định dạng tin nhắn bằng Markdown mượt mà.

2. **Quản Lý API Key An Toàn Trên Client-side**:
   - Nhập Gemini API Key trực tiếp trên giao diện Settings và lưu ở LocalStorage.
   - Bảo mật 100% không lo bị lộ Key khi deploy công khai trên GitHub Pages.
   - Nút 1-click liên kết trực tiếp tới [Google AI Studio](https://aistudio.google.com/app/apikey) lấy Key miễn phí.

3. **Bộ Trắc Nghiệm Hướng Nghiệp Holland (Holland Quiz)**:
   - 6 câu hỏi khảo sát ngắn phân tích 6 nhóm tính cách (Realistic, Investigative, Artistic, Social, Enterprising, Conventional).
   - Nút chuyển tự động kết quả trắc nghiệm sang Chatbot để AI tư vấn ngành phù hợp.

4. **Danh Mục Tra Cứu Ngành Hot (Career Explorer)**:
   - Bộ sưu tập thẻ ngành học hot nhất tại Việt Nam (CNTT, Marketing, Y Khoa, QTKD, Thiết kế đồ họa...).
   - Bộ lọc theo khối thi (A00, A01, B00, C00, D01...) và nút gửi thắc mắc trực tiếp cho AI.

5. **Giao Diện Hiện Đại & Responsive**:
   - Thiết kế Glassmorphism, phong cách hiện đại với font `Plus Jakarta Sans`.
   - Hỗ trợ chế độ Sáng / Tối (Dark / Light Mode).

---

## 🚀 Hướng Dẫn Khởi Chạy Local (Development)

### Yêu cầu tiên quyết
- Cần cài đặt **Node.js (phiên bản v18 trở lên)** và **npm**.

### Các bước thực hiện:

1. Chuyển vào thư mục dự án:
   ```bash
   cd ChatBot
   ```

2. Cài đặt các thư viện phụ thuộc:
   ```bash
   npm install
   ```

3. Chạy môi trường phát triển (Dev Server):
   ```bash
   npm run dev
   ```
   Mở trình duyệt truy cập đường dẫn local: `http://localhost:5173`.

---

## 🌐 Hướng Dẫn Deploy Công Khai Lên GitHub Pages

### Cách 1: Tự động qua GitHub Actions (Khuyên dùng)

1. Tạo repository mới trên GitHub (ví dụ: `ChatBot`).
2. Mở terminal tại thư mục `ChatBot` và đẩy code lên:
   ```bash
   git init
   git add .
   git commit -m "feat: initial commit for EduPath AI Career Chatbot"
   git branch -M main
   git remote add origin https://github.com/<tai-khoan-github-cua-ban>/ChatBot.git
   git push -u origin main
   ```
3. GitHub Actions sẽ tự động thực thi file `.github/workflows/deploy.yml` để build và tạo nhánh `gh-pages`.
4. Vào cài đặt của Repository trên GitHub: **Settings > Pages > Build and deployment > Source**, chọn nhánh **`gh-pages`** và lưu lại.
5. Trang web của bạn sẽ công khai tại: `https://<tai-khoan-github-cua-ban>.github.io/ChatBot/`.

---

## 🛠️ Công Nghệ Sử Dụng

- **Frontend Framework**: React 18
- **Build Tool**: Vite
- **Styling**: Vanilla CSS3 (Custom Design System, Glassmorphism, CSS Variables)
- **Icons**: Lucide React
- **Markdown Renderer**: React Markdown
- **AI Model**: Google Gemini 1.5 Flash (`generativelanguage.googleapis.com`)
