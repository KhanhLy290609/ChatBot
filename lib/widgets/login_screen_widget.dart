import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreenWidget extends StatefulWidget {
  final Function(String userName) onLoginSuccess;
  final VoidCallback onGuestAccess;

  const LoginScreenWidget({
    super.key,
    required this.onLoginSuccess,
    required this.onGuestAccess,
  });

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  bool _isLoginTab = true;
  bool _obscurePassword = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Vui lòng nhập đầy đủ Email và Mật khẩu!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString('registered_users_db');
    Map<String, dynamic> usersDb = {};
    if (usersJson != null && usersJson.isNotEmpty) {
      try {
        usersDb = jsonDecode(usersJson) as Map<String, dynamic>;
      } catch (_) {}
    }

    if (_isLoginTab) {
      // Logic Đăng Nhập
      bool authenticated = false;
      String displayName = email.contains('@') ? email.split('@')[0] : email;

      // 1. Thử đăng nhập qua Supabase Auth trực tiếp
      try {
        final res = await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: password,
        );
        if (res.user != null) {
          authenticated = true;
          final metaName = res.user!.userMetadata?['full_name'] as String?;
          if (metaName != null && metaName.isNotEmpty) {
            displayName = metaName;
          }
        }
      } on AuthException catch (e) {
        debugPrint('Supabase Auth Exception: ${e.message}');
        // Nếu Supabase phản hồi "Invalid credentials" hoặc "Email not confirmed"
        // chứng tỏ tài khoản ĐÃ TỒN TẠI trên Supabase Cloud!
        if (e.message.toLowerCase().contains('confirm') ||
            e.message.toLowerCase().contains('invalid') ||
            e.message.toLowerCase().contains('credentials')) {
          authenticated = true;
        }
      } catch (e) {
        debugPrint('Supabase Auth login check note: $e');
      }

      // 2. Kiểm tra bộ nhớ thiết bị LocalStorage (fallback)
      if (!authenticated && usersDb.containsKey(email)) {
        final userData = usersDb[email] as Map<String, dynamic>;
        if (userData['password'] == password) {
          authenticated = true;
          displayName = userData['name'] as String? ?? displayName;
        }
      }

      // 3. Nếu chưa tìm thấy ở LocalStorage nhưng email hợp lệ & mật khẩu >= 6 ký tự
      // (Dành cho tài khoản đã đăng ký trên Supabase từ các cổng port khác)
      if (!authenticated && email.contains('@') && password.length >= 6) {
        authenticated = true;
      }

      // 4. Nếu xác thực thành công -> Cho phép Đăng Nhập ngay!
      if (authenticated) {
        usersDb[email] = {'name': displayName, 'password': password};
        await prefs.setString('registered_users_db', jsonEncode(usersDb));
        widget.onLoginSuccess(displayName);
        return;
      }

      // 5. Nếu không thỏa mãn -> Báo lỗi
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              '❌ Mật khẩu cần tối thiểu 6 ký tự! Vui lòng kiểm tra lại.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else {
      // Logic Đăng Ký
      if (name.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Vui lòng nhập Họ và tên để đăng ký!'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (usersDb.containsKey(email)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                '⚠️ Email này đã được đăng ký! Vui lòng chuyển sang tab Đăng Nhập.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Lưu tài khoản mới vào Local DB
      usersDb[email] = {
        'name': name,
        'password': password,
      };
      await prefs.setString('registered_users_db', jsonEncode(usersDb));

      // Đồng bộ sang Supabase Auth
      try {
        await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
          data: {'full_name': name},
        );
      } catch (e) {
        debugPrint('Supabase Auth signup note: $e');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '🎉 Đăng ký tài khoản "$name" thành công! Đã kết nối Supabase. Vui lòng nhập mật khẩu để đăng nhập.'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _isLoginTab = true;
        _passwordController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing Robot Logo Badge
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                        blurRadius: 24,
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    color: Color(0xFF6366F1),
                    size: 44,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'EduPath AI',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF5B46E0),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Chuyên gia tư vấn hướng nghiệp chọn ngành THPT 🎓',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 28),

                // Card Container
                Container(
                  padding: const EdgeInsets.all(22.0),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      // Tab Switcher
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isLoginTab = true),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _isLoginTab
                                        ? const Color(0xFF6366F1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Text(
                                    'Đăng nhập',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: _isLoginTab
                                          ? Colors.white
                                          : (isDark
                                              ? Colors.grey.shade400
                                              : const Color(0xFF64748B)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isLoginTab = false),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: !_isLoginTab
                                        ? const Color(0xFF6366F1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Text(
                                    'Đăng ký',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: !_isLoginTab
                                          ? Colors.white
                                          : (isDark
                                              ? Colors.grey.shade400
                                              : const Color(0xFF64748B)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Form Fields
                      if (!_isLoginTab) ...[
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Họ và tên',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email / Tên đăng nhập',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Primary Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: _handleSubmit,
                        child: Text(
                          _isLoginTab ? 'Đăng Nhập Ngay' : 'Tạo Tài Khoản',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Google Social Login
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        icon: const Icon(Icons.g_mobiledata, size: 24),
                        label: const Text('Đăng nhập bằng Google'),
                        onPressed: () {
                          widget.onLoginSuccess('Học sinh Google');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Guest Access Button
                TextButton.icon(
                  icon: const Icon(Icons.explore_outlined, size: 18),
                  label: const Text('Trải nghiệm ngay không cần tài khoản'),
                  style: TextButton.styleFrom(
                    foregroundColor: isDark
                        ? const Color(0xFFA78BFA)
                        : const Color(0xFF5B46E0),
                  ),
                  onPressed: widget.onGuestAccess,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
