import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
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

  Future<Uint8List> _downscaleImageBytes(Uint8List inputBytes, {int targetWidth = 200}) async {
    try {
      final codec = await ui.instantiateImageCodec(
        inputBytes,
        targetWidth: targetWidth,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        return byteData.buffer.asUint8List();
      }
    } catch (e) {
      debugPrint('Downscale avatar error: $e');
    }
    return inputBytes;
  }

  Future<void> _pickImageFromDevice() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          final smallBytes = await _downscaleImageBytes(file.bytes!, targetWidth: 200);
          final base64Image = 'data:image/png;base64,${base64Encode(smallBytes)}';
          widget.onUpdateAvatar(base64Image);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.selectedLanguage == 'en'
                    ? '🎉 Personal avatar updated successfully!'
                    : '🎉 Đã chọn & cập nhật ảnh Avatar thành công!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Pick image error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ Lỗi chọn ảnh: $e')),
        );
      }
    }
  }

  void _showAvatarDialog() {
    final isEn = widget.selectedLanguage == 'en';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEn ? 'Change Personal Avatar' : 'Thay Đổi Ảnh Avatar Cá Nhân'),
        content: StatefulBuilder(
          builder: (dialogCtx, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                icon: const Icon(Icons.upload_file_rounded, size: 20),
                label: Text(
                  isEn ? '📁 Pick Image From Device' : '📁 Chọn Ảnh Từ Thiết Bị',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  _pickImageFromDevice();
                },
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Text(
                isEn ? 'Or choose sample avatar:' : 'Hoặc chọn Avatar mẫu:',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _presetAvatars.map((preset) {
                  return ActionChip(
                    label: Text(preset['label']!),
                    onPressed: () {
                      widget.onUpdateAvatar(preset['url']!);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isEn
                              ? 'Avatar updated!'
                              : 'Đã cập nhật Avatar mẫu thành công!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              Text(
                isEn ? 'Or paste Image URL:' : 'Hoặc dán đường dẫn ảnh (URL):',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _avatarUrlController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'https://example.com/avatar.png',
                  labelText: isEn ? 'Image URL' : 'URL Ảnh Cá Nhân',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isEn ? 'Cancel' : 'Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
            onPressed: () {
              final url = _avatarUrlController.text.trim();
              if (url.isNotEmpty) {
                widget.onUpdateAvatar(url);
              }
              Navigator.pop(ctx);
            },
            child: Text(
              isEn ? 'Update' : 'Cập Nhật Ảnh',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarWidget(String url, double radius) {
    if (url.startsWith('data:image')) {
      try {
        final base64Str = url.split(',').last;
        final bytes = base64Decode(base64Str);
        return ClipOval(
          child: Image.memory(
            bytes,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stack) => _fallbackAvatar(radius),
          ),
        );
      } catch (_) {}
    } else if (url.startsWith('http')) {
      return ClipOval(
        child: Image.network(
          url,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stack) => _fallbackAvatar(radius),
        ),
      );
    }
    return _fallbackAvatar(radius);
  }

  Widget _fallbackAvatar(double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: widget.primaryColor.withValues(alpha: 0.15),
      child: Icon(Icons.person, size: radius * 1.1, color: widget.primaryColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = widget.selectedLanguage == 'en';

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
                  _buildAvatarWidget(widget.avatarUrl, 46),
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
                widget.userName.isNotEmpty
                    ? widget.userName
                    : (isEn ? 'Student' : 'Học sinh'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.userEmail.isNotEmpty
                    ? widget.userEmail
                    : (isEn ? 'No Email registered' : 'Chưa có Email'),
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
        _buildSectionHeader(
            isEn ? 'Account & Personal Info' : 'Tài Khoản & Thông Tin Cá Nhân',
            isDark),
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
                  labelText: isEn ? 'Display Name' : 'Tên hiển thị',
                  prefixIcon: const Icon(Icons.person_outline),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      widget.onUpdateName(_nameController.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(isEn
                                ? 'Display name updated!'
                                : 'Đã cập nhật tên thành công!')),
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
                title: Text(
                    isEn ? 'Email Address / Gmail' : 'Địa chỉ Email / Gmail',
                    style: const TextStyle(fontSize: 13)),
                subtitle: Text(
                  widget.userEmail.isNotEmpty
                      ? widget.userEmail
                      : (isEn ? 'Guest (Unregistered)' : 'Khách (Chưa đăng ký)'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Section: Appearance Accent Color
        _buildSectionHeader(
            isEn
                ? 'Theme Accent Color'
                : 'Màu Chủ Đạo Giao Diện (Theme Accent)',
            isDark),
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
        _buildSectionHeader(
            isEn ? 'Application Language' : 'Ngôn Ngữ Ứng Dụng (Language)',
            isDark),
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
        _buildSectionHeader(
            isEn ? 'Gemini API Key Setup' : 'Cấu Hình Gemini API Key', isDark),
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
                    SnackBar(
                        content: Text(
                            isEn ? 'Saved API Key!' : 'Đã lưu API Key mới thành công!')),
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
          label: Text(
            isEn ? 'Log Out Account' : 'Đăng Xuất Tài Khoản',
            style: const TextStyle(fontWeight: FontWeight.bold),
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
