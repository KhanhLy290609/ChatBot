# Design Spec: EduPath AI - Re-design Giao Diện Mới (Modern Mobile UI)

**Ngày cập nhật:** 2026-08-02  
**Vị trí dự án:** `d:\ChatBot`  
**Yêu cầu cốt lõi:** Thay đổi toàn bộ Giao diện người dùng (UI) theo phong cách Modern Mobile UI (hình mẫu đính kèm), đồng thời **GIỮ NGUYÊN 100% CÁC CHỨC NĂNG CŨ** (Chatbot Gemini 3.6, Holland Quiz, Tra cứu Ngành hot, Cài đặt API Key, Chế độ Tối/Sáng).

---

## 1. Chi Tiết Giao Diện Mới

### A. Header (Thanh Tiêu Đề Trên Cùng)
- **Bên trái**: Logo Con Robot AI 🤖 (đặt trong icon badge tròn màu tím) + Tên ứng dụng `EduPath AI` (chữ tím đậm `0xFF5B46E0`) + Lời chào `Chào buổi sáng! 👋`.
- **Bên phải**:
  - Icon **Bánh Răng ⚙️ (Settings)**: Bấm để mở Modal Cấu hình API Key.
  - Icon **Mặt trăng / Mặt trời 🌙/☀️**: Bấm để chuyển đổi chế độ Sáng / Tối.

### B. Thẻ Chào Mừng (Welcome Hero Card)
- Khung thẻ bo góc 24px với nền Gradient Tím nhạt (`#FAF7FF` đến `#F3ECFF`).
- Tiêu đề chữ tím đậm: **"Xin chào! Mình là EduPath AI"**
- Đoạn giới thiệu định hướng ngắn gọn.

### C. Nút Gợi Ý Nhanh (Pill Prompt Chips)
- Các nút bo tròn viên thuốc Pill (Radius 50px), nền trắng ngọc trai, chữ màu tím:
  1. *"Tôi giỏi Toán và Lý"*
  2. *"Khối A01 học ngành gì?"*
  3. *"AI có phù hợp với mình?"*
  4. *"Ngành hot 2026"*

### D. Khung Tin Nhắn (Chat Message List)
- **AI Assistant**: Avatar hình lấp lánh `✨` nền tím 🟣. Bong bóng tin nhắn màu tím Lavender nhạt (`#F1EAFF`), bo góc 18px (đuôi bên trái).
- **User (Học sinh)**: Avatar hình cá nhân 👩 bên phải. Bong bóng tin nhắn màu hồng phấn nhạt (`#FCE4FF`), bo góc 18px (đuôi bên phải).

### E. Thanh Nhập Liệu & Bottom Dock Nổi (Floating Navigation)
- **Thanh nhập liệu**: Bo tròn nhạt `#F8F6FF`, icon `+` bên trái, ô nhập chữ giữa, nút **Gửi màu tím tròn** bên phải.
- **Floating Bottom Dock**: Thanh menu nổi phía dưới gồm 3 Tab:
  - 💬 **Chat** (Active màu tím nổi bật)
  - 🧠 **Holland Test** (Trắc nghiệm hướng nghiệp)
  - 💼 **Careers** (Tra cứu ngành hot)

---

## 2. Bảo Tồn Chức Năng Cũ (Preserved Features)
1. Tự động dùng API Key đã nhúng (`AQ.Ab8RN6J6...`) và hỗ trợ nhập API Key riêng trong Settings Modal (bấm icon Bánh Răng ⚙️).
2. Mô hình AI Gemini 3.6 Flash với Multi-model fallback (`gemini-3.6-flash`, `gemini-2.0-flash`).
3. Bài trắc nghiệm Holland 6 câu hỏi khảo sát + chuyển tự động kết quả cho Chatbot.
4. Tra cứu danh mục các ngành học hot tại Việt Nam + lọc khối thi.
