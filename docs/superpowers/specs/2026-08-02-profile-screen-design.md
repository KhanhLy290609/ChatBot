# Design Spec: EduPath AI - Màn Hình Thông Tin Cá Nhân & Cài Đặt Profile

**Ngày cập nhật:** 2026-08-02  
**Vị trí dự án:** `d:\ChatBot`  

---

## 1. Mục Tiêu
Tạo Màn hình Thông tin Cá nhân & Cài đặt Profile (Profile Screen) cho phép người dùng tự tải/nhập ảnh avatar cá nhân, thay đổi tên đăng nhập, xem Gmail, đổi ngôn ngữ, đổi màu chủ đạo giao diện và đăng xuất.

## 2. Các Thành Phần Giao Diện & Tính Năng

### A. Quản Lý Avatar Cá Nhân (Custom Avatar Upload & Presets)
- Xem trước Avatar cá nhân (Live Avatar Preview).
- Cho phép người dùng dán **Đường dẫn Ảnh cá nhân (Image URL / Base64)** hoặc chọn Avatar mẫu nhanh (Học sinh 👩/👦, Cử nhân 🎓, Robot 🤖...).
- Cập nhật Avatar trực tiếp trong danh sách bong bóng Chat & Header.

### B. Thông Tin Cá Nhân & Gmail
- Tên đăng nhập (Username): Cho phép chỉnh sửa tên hiển thị.
- Gmail: Hiển thị Email cá nhân đã đăng ký.

### C. Đổi Màu Chủ Đạo Giao Diện (Theme Accent Color)
- 5 màu chủ đề:
  1. 🟣 **Tím Indigo** (`#6366F1`) - Mặc định
  2. 💖 **Hồng Phấn Rose** (`#EC4899`)
  3. 🌊 **Xanh Đại Dương Cyan** (`#06B6D4`)
  4. 🌿 **Xanh Ngọc Emerald** (`#10B981`)
  5. 🍊 **Cam Ấm Amber** (`#F59E0B`)
- Đổi màu toàn bộ ứng dụng (Buttons, Tabs, Indicators, Accents).

### D. Thay Đổi Ngôn Ngữ (Language Selection)
- Tùy chọn 🇻🇳 **Tiếng Việt** / 🇬🇧 **English**.
- Tự động thay đổi ngôn ngữ hướng dẫn của AI.

### E. Cấu Hình API Key & Nút Đăng Xuất (Logout)
- Cấu hình Gemini API Key.
- Nút **Đăng Xuất** màu đỏ ở cuối trang.
