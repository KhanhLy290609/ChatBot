import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/hero_welcome_card.dart';
import 'widgets/pill_prompt_chips.dart';
import 'widgets/floating_bottom_dock.dart';
import 'widgets/holland_quiz_widget.dart';
import 'widgets/career_explorer_widget.dart';

void main() {
  runApp(const EduPathApp());
}

class EduPathApp extends StatefulWidget {
  const EduPathApp({super.key});

  @override
  State<EduPathApp> createState() => _EduPathAppState();
}

class _EduPathAppState extends State<EduPathApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduPath AI - Tư Vấn Hướng Nghiệp THPT',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFF8B5CF6),
          surface: const Color(0xFFF8FAFC),
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.light().textTheme,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
          primary: const Color(0xFF818CF8),
          secondary: const Color(0xFFA78BFA),
          surface: const Color(0xFF0F172A),
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: HomeScreen(onToggleTheme: toggleTheme, themeMode: _themeMode),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;
  static String get _defaultApiKey => utf8.decode(base64.decode(
      'QVEuQWI4Uk42SjZtTEZiQnFSSGVFRldVOE5FRnJOQzJlRWVBVVFVeTJXX2RfODV5NzlsSVE='));

  String _apiKey = _defaultApiKey;
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiKey = prefs.getString('gemini_api_key') ?? _defaultApiKey;
      if (_apiKey.trim().isEmpty) {
        _apiKey = _defaultApiKey;
      }
    });
  }

  Future<void> _saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gemini_api_key', key);
    setState(() {
      _apiKey = key.trim().isEmpty ? _defaultApiKey : key.trim();
    });
  }

  void _openSettingsDialog() {
    final keyController = TextEditingController(text: _apiKey);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.settings, color: Color(0xFF6366F1)),
            SizedBox(width: 8),
            Text(
              'Cấu Hình Gemini API Key',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nhập API Key cá nhân của bạn nếu muốn đổi Key mặc định:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: keyController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'AIzaSy...',
                labelText: 'Gemini API Key',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Mặc định: Key hệ thống đã được tích hợp sẵn.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              _saveApiKey(keyController.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Lưu Key'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final apiKeyToUse =
        _apiKey.trim().isNotEmpty ? _apiKey.trim() : _defaultApiKey;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isLoading = true;
    });
    _inputController.clear();

    try {
      const systemPrompt =
          "Bạn là EduPath AI - Chuyên gia Tư vấn Hướng nghiệp THPT tại Việt Nam. Hãy tư vấn định hướng ngành học, khối thi (A00, A01, B00, C00, D01...), điểm chuẩn tham khảo, cơ hội việc làm & trường Đại học bằng tiếng Việt thân thiện, thấu hiểu và sử dụng định dạng Markdown.";

      final contents = _messages
          .map((m) => {
                'role': m['role'] == 'user' ? 'user' : 'model',
                'parts': [
                  {'text': m['content']}
                ]
              })
          .toList();

      final candidateModels = [
        'gemini-3.6-flash',
        'gemini-2.0-flash',
        'gemini-flash-latest',
      ];

      http.Response? response;
      for (final modelName in candidateModels) {
        final url = Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$apiKeyToUse');

        final res = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'system_instruction': {
              'parts': [
                {'text': systemPrompt}
              ]
            },
            'contents': contents,
          }),
        );

        if (res.statusCode == 200) {
          response = res;
          break;
        } else {
          response = res;
        }
      }

      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String botText = 'Không có phản hồi từ AI.';
        final parts = data['candidates']?[0]?['content']?['parts'] as List?;
        if (parts != null && parts.isNotEmpty) {
          for (final part in parts) {
            if (part is Map &&
                part.containsKey('text') &&
                (part['text'] as String).trim().isNotEmpty) {
              botText = part['text'] as String;
            }
          }
        }
        setState(() {
          _messages.add({'role': 'assistant', 'content': botText});
        });
      } else if (response != null && response.statusCode == 429) {
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content':
                '⚠️ Hệ thống AI vừa chạm giới hạn tần suất (Quota Exceeded / 429). Vui lòng chờ khoảng 30 giây rồi gửi lại câu hỏi nhé!'
          });
        });
      } else {
        final errCode = response?.statusCode ?? 'Unknown';
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content':
                '⚠️ Lỗi kết nối Gemini API ($errCode). Vui lòng thử lại sau giây lát!'
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': '⚠️ Đã xảy ra lỗi kết nối mạng. Vui lòng thử lại!'
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sendFromOtherTabs(String message) {
    setState(() {
      _currentTabIndex = 0;
    });
    _sendMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Color(0xFF6366F1),
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EduPath AI',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Color(0xFF5B46E0),
                  ),
                ),
                Text(
                  'Chào buổi sáng! 👋',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Moon/Sun icon next to far-right Gear icon
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.light
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              color: isDark ? const Color(0xFFA78BFA) : const Color(0xFF6366F1),
            ),
            tooltip: 'Chuyển Chế Độ Tối/Sáng',
            onPressed: widget.onToggleTheme,
          ),
          // Gear Settings icon on the FAR RIGHT
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: isDark ? const Color(0xFFA78BFA) : const Color(0xFF6366F1),
            ),
            tooltip: 'Cài đặt API Key',
            onPressed: _openSettingsDialog,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: _currentTabIndex,
                  children: [
                    _buildChatTab(isDark),
                    HollandQuizWidget(onSendToChat: _sendFromOtherTabs),
                    CareerExplorerWidget(onAskAI: _sendFromOtherTabs),
                  ],
                ),
              ),
              // Reserve bottom space for floating dock
              const SizedBox(height: 70),
            ],
          ),
          // Floating Bottom Navigation Dock
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingBottomDock(
              currentIndex: _currentTabIndex,
              onTapTab: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      children: [
        const HeroWelcomeCard(),
        const SizedBox(height: 20),
        PillPromptChips(onPromptSelected: _sendMessage),
        const SizedBox(height: 16),
        ..._messages.map((msg) {
          final isUser = msg['role'] == 'user';
          return Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: Row(
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isUser) ...[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6366F1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: isUser
                          ? (isDark
                              ? const Color(0xFF831843)
                              : const Color(0xFFFCE4FF))
                          : (isDark
                              ? const Color(0xFF312E81)
                              : const Color(0xFFF1EAFF)),
                      borderRadius: BorderRadius.circular(18.0).copyWith(
                        bottomLeft: !isUser ? const Radius.circular(0) : null,
                        bottomRight: isUser ? const Radius.circular(0) : null,
                      ),
                    ),
                    child: isUser
                        ? Text(
                            msg['content']!,
                            style: TextStyle(
                              fontSize: 14.5,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1F2937),
                              height: 1.45,
                            ),
                          )
                        : MarkdownBody(
                            data: msg['content']!,
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                fontSize: 14.5,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1F2937),
                                height: 1.45,
                              ),
                            ),
                          ),
                  ),
                ),
                if (isUser) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEC4899),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ]
              ],
            ),
          );
        }),
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6366F1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF312E81)
                        : const Color(0xFFF1EAFF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        // Floating Input Field Container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8F6FF),
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE9D5FF),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: isDark
                      ? const Color(0xFFA78BFA)
                      : const Color(0xFF6366F1),
                ),
                onPressed: () {},
              ),
              Expanded(
                child: TextField(
                  controller: _inputController,
                  decoration: const InputDecoration(
                    hintText: 'Hỏi EduPath về ngành nghề,...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: _sendMessage,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF6366F1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () => _sendMessage(_inputController.text),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
