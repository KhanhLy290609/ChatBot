import 'package:flutter/material.dart';

class HollandQuizWidget extends StatefulWidget {
  final Function(String) onSendToChat;
  final Color primaryColor;
  final String language;

  const HollandQuizWidget({
    super.key,
    required this.onSendToChat,
    this.primaryColor = const Color(0xFF6366F1),
    this.language = 'vi',
  });

  @override
  State<HollandQuizWidget> createState() => _HollandQuizWidgetState();
}

class _HollandQuizWidgetState extends State<HollandQuizWidget> {
  int _currentQ = 0;
  final Map<int, String> _answers = {};

  static const Map<String, Map<String, dynamic>> _hollandInfoVi = {
    'R': {
      'name': 'Kỹ Thuật / Thực Thực (Realistic)',
      'desc': 'Bạn có thiên hướng thích làm việc với công cụ, máy móc, vật dụng thực tế hoặc hoạt động ngoài trời.',
      'majors': ['CNTT / Ô tô', 'Kỹ thuật Cơ khí', 'Điện - Điện tử', 'Xây dựng'],
    },
    'I': {
      'name': 'Nghiên Cứu / Khám Phá (Investigative)',
      'desc': 'Bạn có tư duy phân tích, thích giải quyết các bài toán phức tạp và khám phá tri thức mới.',
      'majors': ['Khoa học Máy tính / AI', 'Data Science', 'Công nghệ Sinh học', 'Y Dược'],
    },
    'A': {
      'name': 'Nghệ Thuật / Sáng Tạo (Artistic)',
      'desc': 'Bạn giàu trí tưởng tượng, tự do và có tâm hồn sáng tạo nghệ thuật độc đáo.',
      'majors': ['Thiết kế Đồ họa / UI UX', 'Truyền thông', 'Kiến trúc', 'Thời trang'],
    },
    'S': {
      'name': 'Xã Hội / Giúp Đỡ (Social)',
      'desc': 'Bạn thích chia sẻ, giảng dạy, tư vấn và giúp đỡ mọi người xung quanh.',
      'majors': ['Sư phạm', 'Tâm lý học', 'Quản trị Nhân sự', 'Công tác xã hội'],
    },
    'E': {
      'name': 'Quản Lý / Thuyết Phục (Enterprising)',
      'desc': 'Bạn tự tin, giao tiếp tốt, thích làm nhóm trưởng, kinh doanh và thăng tiến.',
      'majors': ['Quản trị Kinh doanh', 'Marketing / PR', 'Tài chính - Ngân hàng', 'Luật'],
    },
    'C': {
      'name': 'Nghiệp Vụ / Tỉ Mỉ (Conventional)',
      'desc': 'Bạn cẩn thận, chỉn chu, ngăn nắp, giỏi xử lý số liệu và làm việc theo quy trình.',
      'majors': ['Kế toán / Kiểm toán', 'Tài chính Công', 'Thống kê Dữ liệu', 'Hành chính'],
    },
  };

  static const Map<String, Map<String, dynamic>> _hollandInfoEn = {
    'R': {
      'name': 'Realistic (Practical / Technical)',
      'desc': 'You prefer working with tools, machinery, physical objects, or outdoor activities.',
      'majors': ['IT / Automotive', 'Mechanical Engineering', 'Electronics', 'Construction'],
    },
    'I': {
      'name': 'Investigative (Research / Analytical)',
      'desc': 'You have strong analytical thinking, enjoy solving complex problems and acquiring new knowledge.',
      'majors': ['Computer Science / AI', 'Data Science', 'Biotechnology', 'Medicine'],
    },
    'A': {
      'name': 'Artistic (Creative / Imaginative)',
      'desc': 'You are imaginative, independent, and possess a unique artistic soul.',
      'majors': ['Graphic Design / UI UX', 'Media & Comm', 'Architecture', 'Fashion'],
    },
    'S': {
      'name': 'Social (Helping / Teaching)',
      'desc': 'You enjoy sharing, teaching, counseling, and helping people around you.',
      'majors': ['Pedagogy / Education', 'Psychology', 'Human Resources', 'Social Work'],
    },
    'E': {
      'name': 'Enterprising (Leadership / Business)',
      'desc': 'You are confident, communicative, enjoy leading teams, business, and driving advancement.',
      'majors': ['Business Admin', 'Marketing / PR', 'Finance & Banking', 'Law'],
    },
    'C': {
      'name': 'Conventional (Organized / Detail-Oriented)',
      'desc': 'You are careful, organized, skilled at data processing and structured workflows.',
      'majors': ['Accounting / Auditing', 'Public Finance', 'Data Statistics', 'Administration'],
    },
  };

  final List<Map<String, dynamic>> _questionsVi = const [
    {
      'question': '1. Khi rảnh rỗi, bạn thích thực hiện hoạt động nào nhất?',
      'options': [
        {'text': 'Sửa chữa đồ dùng, lắp ráp máy móc, Lego.', 'type': 'R'},
        {'text': 'Đọc sách khoa học, suy nghĩ giải bài toán khó.', 'type': 'I'},
        {'text': 'Vẽ tranh, viết lách, chụp ảnh, nghe nhạc.', 'type': 'A'},
        {'text': 'Trò chuyện, tâm sự, giúp đỡ bạn bè.', 'type': 'S'},
        {'text': 'Làm nhóm trưởng, thuyết phục người khác.', 'type': 'E'},
        {'text': 'Sắp xếp đồ đạc ngăn nắp, quản lý kế hoạch.', 'type': 'C'},
      ]
    },
    {
      'question': '2. Môn học THPT nào khiến bạn tự tin nhất?',
      'options': [
        {'text': 'Vật lý thực hành, Công nghệ, Thể dục.', 'type': 'R'},
        {'text': 'Toán học, Hóa học, Sinh học, Tin học.', 'type': 'I'},
        {'text': 'Ngữ văn, Mỹ thuật, Âm nhạc.', 'type': 'A'},
        {'text': 'Tiếng Anh, GDCD, Hoạt động trải nghiệm.', 'type': 'S'},
        {'text': 'Địa lý, Thuyết trình nhóm.', 'type': 'E'},
        {'text': 'Tin học văn phòng, Ghi chép bài chỉn chu.', 'type': 'C'},
      ]
    },
    {
      'question': '3. Vai trò yêu thích của bạn khi làm bài tập nhóm?',
      'options': [
        {'text': 'Chuẩn bị đạo cụ, thực hành kỹ thuật.', 'type': 'R'},
        {'text': 'Nghiên cứu tài liệu, giải quyết câu hỏi khó.', 'type': 'I'},
        {'text': 'Thiết kế slide PowerPoint, kịch bản sáng tạo.', 'type': 'A'},
        {'text': 'Hỗ trợ giải đáp thắc mắc cho các thành viên.', 'type': 'S'},
        {'text': 'Làm nhóm trưởng, phân công công việc.', 'type': 'E'},
        {'text': 'Tổng hợp bài làm, kiểm tra lỗi nộp đúng hạn.', 'type': 'C'},
      ]
    }
  ];

  final List<Map<String, dynamic>> _questionsEn = const [
    {
      'question': '1. In your free time, which activity do you enjoy most?',
      'options': [
        {'text': 'Fixing things, assembling machines or Lego.', 'type': 'R'},
        {'text': 'Reading science books, solving difficult math problems.', 'type': 'I'},
        {'text': 'Drawing, writing, photography, listening to music.', 'type': 'A'},
        {'text': 'Chatting, comforting, helping friends.', 'type': 'S'},
        {'text': 'Being team leader, persuading others.', 'type': 'E'},
        {'text': 'Organizing things neatly, managing schedules.', 'type': 'C'},
      ]
    },
    {
      'question': '2. Which high school subject makes you feel most confident?',
      'options': [
        {'text': 'Physics lab, Technology, Physical Education.', 'type': 'R'},
        {'text': 'Mathematics, Chemistry, Biology, IT.', 'type': 'I'},
        {'text': 'Literature, Fine Arts, Music.', 'type': 'A'},
        {'text': 'English, Civics, Experiential Activities.', 'type': 'S'},
        {'text': 'Geography, Group Presentations.', 'type': 'E'},
        {'text': 'Office IT, Taking neat notes.', 'type': 'C'},
      ]
    },
    {
      'question': '3. Your favorite role during group projects?',
      'options': [
        {'text': 'Preparing props, technical implementation.', 'type': 'R'},
        {'text': 'Researching materials, solving tough questions.', 'type': 'I'},
        {'text': 'Designing slides, creative scriptwriting.', 'type': 'A'},
        {'text': 'Supporting team members with questions.', 'type': 'S'},
        {'text': 'Team leader, task assignment.', 'type': 'E'},
        {'text': 'Compiling final work, checking errors & deadlines.', 'type': 'C'},
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = widget.primaryColor;
    final isEn = widget.language == 'en';

    final hollandInfo = isEn ? _hollandInfoEn : _hollandInfoVi;
    final questions = isEn ? _questionsEn : _questionsVi;

    if (_currentQ >= questions.length) {
      final counts = <String, int>{'R': 0, 'I': 0, 'A': 0, 'S': 0, 'E': 0, 'C': 0};
      for (final type in _answers.values) {
        counts[type] = (counts[type] ?? 0) + 1;
      }
      final sorted = counts.keys.toList()
        ..sort((a, b) => counts[b]!.compareTo(counts[a]!));
      final topType = sorted.first;
      final info = hollandInfo[topType]!;
      final List<String> majors = List<String>.from(info['majors']);

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          Container(
            padding: const EdgeInsets.all(22.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        primary.withValues(alpha: 0.3),
                        primary.withValues(alpha: 0.15)
                      ]
                    : [
                        primary.withValues(alpha: 0.06),
                        primary.withValues(alpha: 0.14)
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color: primary.withValues(alpha: isDark ? 0.4 : 0.25),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isEn ? 'Holland Test Results' : 'Kết quả Trắc nghiệm Holland',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEn
                      ? 'Holland Code $topType - ${info['name']}'
                      : 'Mã $topType - ${info['name']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  info['desc'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isEn ? 'Recommended Major Groups:' : 'Các nhóm ngành gợi ý:',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: majors.map((m) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        m,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: Text(
                    isEn
                        ? 'Send Result to AI for Detailed Counseling'
                        : 'Gửi Cho AI Tư Vấn Ngành Cụ Thể',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    widget.onSendToChat(
                      isEn
                          ? 'I just completed the Holland test and my top group is **Holland Code $topType - ${info['name']}**.\nPlease provide detailed analysis on suitable university majors and career paths!'
                          : 'Tớ vừa hoàn thành bài trắc nghiệm Holland và có kết quả nhóm nổi bật nhất là **Mã $topType - ${info['name']}**.\nNhờ EduPath AI phân tích chi tiết các ngành học phù hợp, điểm chuẩn và trường Đại học tương ứng!',
                    );
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentQ = 0;
                      _answers.clear();
                    });
                  },
                  child: Text(
                    isEn ? 'Retake Test' : 'Làm lại trắc nghiệm',
                    style: TextStyle(
                      color: isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final q = questions[_currentQ];
    final options = q['options'] as List;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: (_currentQ + 1) / questions.length,
            color: primary,
            backgroundColor: isDark
                ? const Color(0xFF1E293B)
                : const Color(0xFFE2E8F0),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isEn
              ? 'Question ${_currentQ + 1} / ${questions.length}'
              : 'Câu ${_currentQ + 1} / ${questions.length}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          q['question'] as String,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 20),
        ...options.map((opt) {
          final optionMap = opt as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _answers[_currentQ] = optionMap['type'] as String;
                  _currentQ++;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        optionMap['text'] as String,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.grey.shade200
                              : const Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: primary,
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
