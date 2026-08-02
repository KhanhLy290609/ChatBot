import 'package:flutter/material.dart';

class ProfileScreenWidget extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String avatarUrl;
  final String selectedLanguage;
  final Color primaryColor;
  final String apiKey;

  final Function(String newName) onUpdateName;
  final Function(String newAvatar) onUpdateAvatar;
  final Function(Color newColor) onUpdateColor;
  final Function(String newLang) onUpdateLanguage;
  final Function(String newKey) onUpdateApiKey;
  final VoidCallback onLogout;

  const ProfileScreenWidget({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.avatarUrl,
    required this.selectedLanguage,
    required this.primaryColor,
    required this.apiKey,
    required this.onUpdateName,
    required this.onUpdateAvatar,
    required this.onUpdateColor,
    required this.onUpdateLanguage,
    required this.onUpdateApiKey,
    required this.onLogout,
  });

  @override
  State<ProfileScreenWidget> createState() => _ProfileScreenWidgetState();
}

class _ProfileScreenWidgetState extends State<ProfileScreenWidget> {
  late TextEditingController _nameController;
  late TextEditingController _avatarUrlController;
  late TextEditingController _apiKeyController;

  static const List<Map<String, dynamic>> _colorOptions = [
    {'name': 'Tím Indigo', 'color': Color(0xFF6366F1)},
    {'name': 'Hồng Rose', 'color': Color(0xFFEC4899)},
    {'name': 'Xanh Cyan', 'color': Color(0xFF06B6D4)},
    {'name': 'Xanh Emerald', 'color': Color(0xFF10B981)},
    {'name': 'Cam Amber', 'color': Color(0xFFF59E0B)},
  ];

  static const List<Map<String, String>> _presetAvatars = [
    {'label': 'Học sinh 👩', 'url': 'https://api.dicebear.com/7.x/bottts/svg?seed=student1'},
    {'label': 'Học sinh 👦', 'url': 'https://api.dicebear.com/7.x/bottts/svg?seed=student2'},
    {'label': 'Cử nhân 🎓', 'url': 'https://api.dicebear.com/7.x/bottts/svg?seed=grad'},
    {'label': 'Robot 🤖', 'url': 'https://api.dicebear.com/7.x/bottts/svg?seed=robot'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _avatarUrlController = TextEditingController(text: widget.avatarUrl);
    _apiKeyController = TextEditingController(text: widget.apiKey);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarUrlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  void _showAvatarDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thay Đổi Ảnh Avatar Cá Nhân'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dán đường dẫn ảnh (URL) hoặc chọn bên dưới:'),
            const SizedBox(height: 12),
            TextField(
              controller: _avatarUrlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'https://example.com/avatar.png',
                labelText: 'URL Ảnh Cá Nhân',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hoặc chọn Avatar mẫu:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _presetAvatars.map((preset) {
                return ActionChip(
                  label: Text(preset['label']!),
                  onPressed: () {
                    _avatarUrlController.text = preset['url']!;
                  },
                );
              }).toList(),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
            onPressed: () {
              widget.onUpdateAvatar(_avatarUrlController.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Cập Nhật Ảnh', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        // Avatar Header Card
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
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
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: widget.primaryColor.withValues(alpha: 0.15),
                    backgroundImage: widget.avatarUrl.isNotEmpty
                        ? NetworkImage(widget.avatarUrl)
                        : null,
                    child: widget.avatarUrl.isEmpty
                        ? Icon(Icons.person, size: 50, color: widget.primaryColor)
                        : null,
                  ),
                  InkWell(
                    onTap: _showAvatarDialog,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                widget.userName.isNotEmpty ? widget.userName : 'Học sinh',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.userEmail.isNotEmpty ? widget.userEmail : 'Chưa có Email',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Section: Personal Information Edit
        _buildSectionHeader('Tài Khoản & Thông Tin Cá Nhân', isDark),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Tên hiển thị',
                  prefixIcon: const Icon(Icons.person_outline),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      widget.onUpdateName(_nameController.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã cập nhật tên thành công!')),
                      );
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.email_outlined),
                title: const Text('Địa chỉ Email / Gmail', style: TextStyle(fontSize: 13)),
                subtitle: Text(
                  widget.userEmail.isNotEmpty ? widget.userEmail : 'Khách (Chưa đăng ký)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Section: Appearance Accent Color
        _buildSectionHeader('Màu Chủ Đạo Giao Diện (Theme Accent)', isDark),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _colorOptions.map((opt) {
              final color = opt['color'] as Color;
              final isSelected = widget.primaryColor.value == color.value;
              return GestureDetector(
                onTap: () => widget.onUpdateColor(color),
                child: Column(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 22)
                          : null,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      opt['name'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        // Section: Language Selection
        _buildSectionHeader('Ngôn Ngữ Ứng Dụng (Language)', isDark),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Text('🇻🇳 Tiếng Việt'),
                  selected: widget.selectedLanguage == 'vi',
                  onSelected: (val) {
                    if (val) widget.onUpdateLanguage('vi');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceChip(
                  label: const Text('🇬🇧 English'),
                  selected: widget.selectedLanguage == 'en',
                  onSelected: (val) {
                    if (val) widget.onUpdateLanguage('en');
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Section: API Key Configuration
        _buildSectionHeader('Cấu Hình Gemini API Key', isDark),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: TextField(
            controller: _apiKeyController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Gemini API Key',
              prefixIcon: const Icon(Icons.key),
              suffixIcon: IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  widget.onUpdateApiKey(_apiKeyController.text.trim());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã lưu API Key mới thành công!')),
                  );
                },
              ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Logout Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          icon: const Icon(Icons.logout, size: 20),
          label: const Text(
            'Đăng Xuất Tài Khoản',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: widget.onLogout,
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.grey.shade300 : const Color(0xFF4B5563),
      ),
    );
  }
}
