import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static String get _apiKey =>
      utf8.decode(base64.decode('QVEuQWI4Uk42STl4Wi1BOWp5ZnplZjdLSXg2Q3BSVWF2YURUQ2QzTy1JcDNtaXJ2b2k0QQ=='));

  final List<Map<String, String>> _messages = [
    {
      'role': 'assistant',
      'content':
          'Xin chào bạn! Tớ là **EduPath AI** - Chuyên gia tư vấn hướng nghiệp chọn ngành Đại học cho học sinh THPT tại Việt Nam 🎓\n\nBạn đang băn khoăn về chọn ngành học, chọn tổ hợp khối thi (A00, A01, B00, C00, D01...), điểm chuẩn tham khảo hay nhu cầu thị trường lao động? Hãy đặt câu hỏi hoặc thử bài **Trắc nghiệm Holland** nhé!'
    }
  ];
  bool _isLoading = false;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

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

      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key=$_apiKey');

      final response = await http.post(
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

      if (response.statusCode == 200) {
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
      } else if (response.statusCode == 429) {
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content':
                '⚠️ Tài khoản Gemini API vừa chạm giới hạn tần suất (Quota Exceeded / 429). Vui lòng chờ khoảng 30 giây rồi gửi lại câu hỏi nhé!'
          });
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content':
                '⚠️ Lỗi kết nối Gemini API (${response.statusCode}). Vui lòng thử lại sau giây lát!'
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
    _tabController.animateTo(0);
    _sendMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.school, color: Color(0xFF6366F1), size: 28),
            SizedBox(width: 10),
            Text(
              'EduPath AI',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            tooltip: 'Chuyển Chế Độ Tối/Sáng',
            onPressed: widget.onToggleTheme,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6366F1),
          labelColor: const Color(0xFF6366F1),
          tabs: const [
            Tab(icon: Icon(Icons.chat_bubble_outline), text: 'Chatbot AI'),
            Tab(icon: Icon(Icons.explore_outlined), text: 'Trắc Nghiệm Holland'),
            Tab(icon: Icon(Icons.stars_outlined), text: 'Ngành Học Hot'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatTab(),
          HollandQuizWidget(onSendToChat: _sendFromOtherTabs),
          CareerExplorerWidget(onAskAI: _sendFromOtherTabs),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              _buildPromptChip('💡 Tớ giỏi Toán và Lý nên chọn ngành gì?'),
              _buildPromptChip('💻 Khối A01 gồm những ngành CNTT hot nào?'),
              _buildPromptChip('🎨 Học Thiết kế đồ họa cần chuẩn bị gì?'),
              _buildPromptChip('📈 Ngành Marketing lương khởi điểm bao nhiêu?'),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (ctx, idx) {
              final msg = _messages[idx];
              final isUser = msg['role'] == 'user';
              return Align(
                alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.82,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? const Color(0xFF6366F1)
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomRight: isUser ? const Radius.circular(0) : null,
                      bottomLeft: !isUser ? const Radius.circular(0) : null,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: isUser
                      ? Text(
                          msg['content']!,
                          style: const TextStyle(color: Colors.white),
                        )
                      : MarkdownBody(data: msg['content']!),
                ),
              );
            },
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, -2),
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  decoration: const InputDecoration(
                    hintText: 'Đặt câu hỏi cho EduPath AI...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: _sendMessage,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF6366F1)),
                onPressed: () => _sendMessage(_inputController.text),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPromptChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(text, style: const TextStyle(fontSize: 12)),
        onPressed: () => _sendMessage(text),
      ),
    );
  }
}
