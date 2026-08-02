# Design Spec: EduPath AI - Màn Hình Đăng Nhập (Login Screen)

**Ngày cập nhật:** 2026-08-02  
**Vị trí dự án:** `d:\ChatBot`  

---

## 1. Mục Tiêu
Bổ sung Màn hình Đăng nhập (Login Screen) hiện đại đồng bộ 100% với phông chữ *Be Vietnam Pro* và tông màu Tím Indigo / Hồng Lavender của ứng dụng EduPath AI.

## 2. Các Thành Phần Giao Diện

### A. Branding Header
- Logo Con Robot AI 🤖 trong vòng tròn tím phát sáng.
- Tiêu đề **EduPath AI** + Subtitle *"Chuyên gia tư vấn hướng nghiệp chọn ngành THPT 🎓"*.

### B. Form Đăng Nhập & Đăng Ký
- Tab switcher: **Đăng nhập** / **Đăng ký**.
- Ô Email (`Icons.email_outlined`) + Mật khẩu (`Icons.lock_outlined` với toggle 👁️).
- Checkbox "Ghi nhớ đăng nhập" & "Quên mật khẩu?".

### C. Nút Bấm Hành Động
- Nút **Đăng Nhập** Tím Indigo (bo tròn Pill 50px).
- Nút **Đăng nhập bằng Google** 🌐.
- Nút **Trải nghiệm ngay (Khách)** để học sinh vào dùng ngay mà không bắt buộc tạo tài khoản.

### D. Quản Lý Trạng Thái Đăng Nhập
- Lưu tên người dùng/email vào `SharedPreferences`.
- Khi đã đăng nhập, màn hình chính hiển thị tên người dùng trên Header.
- Bổ sung nút **Đăng xuất** trong Settings Dialog (Bánh răng ⚙️).
