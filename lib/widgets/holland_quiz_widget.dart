import 'package:flutter/material.dart';

class HollandQuizWidget extends StatefulWidget {
  final Function(String) onSendToChat;

  const HollandQuizWidget({super.key, required this.onSendToChat});

  @override
  State<HollandQuizWidget> createState() => _HollandQuizWidgetState();
}

class _HollandQuizWidgetState extends State<HollandQuizWidget> {
  int _currentQ = 0;
  final Map<int, String> _answers = {};

  static const Map<String, Map<String, dynamic>> _hollandInfo = {
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

  final List<Map<String, dynamic>> _questions = const [
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_currentQ >= _questions.length) {
      final counts = <String, int>{'R': 0, 'I': 0, 'A': 0, 'S': 0, 'E': 0, 'C': 0};
      for (final type in _answers.values) {
        counts[type] = (counts[type] ?? 0) + 1;
      }
      final sorted = counts.keys.toList()
        ..sort((a, b) => counts[b]!.compareTo(counts[a]!));
      final topType = sorted.first;
      final info = _hollandInfo[topType]!;
      final List<String> majors = List<String>.from(info['majors']);

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          Container(
            padding: const EdgeInsets.all(22.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E1B4B), const Color(0xFF2E1065)]
                    : [const Color(0xFFFAF7FF), const Color(0xFFF3ECFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF4C1D95).withValues(alpha: 0.5)
                    : const Color(0xFFE9D5FF),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.08),
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
                  decoration: const BoxDecoration(
                    color: Color(0xFF6366F1),
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
                  'Kết quả Trắc nghiệm Holland',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade400 : const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mã $topType - ${info['name']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? const Color(0xFFA78BFA) : const Color(0xFF5B46E0),
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
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Các nhóm ngành gợi ý:',
                    style: TextStyle(
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
                        color: isDark
                            ? const Color(0xFF312E81)
                            : const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        m,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFFC084FC)
                              : const Color(0xFF5B46E0),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text(
                    'Gửi Cho AI Tư Vấn Ngành Cụ Thể',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    widget.onSendToChat(
                      'Tớ vừa hoàn thành bài trắc nghiệm Holland và có kết quả nhóm nổi bật nhất là **Mã $topType - ${info['name']}**.\nNhờ EduPath AI phân tích chi tiết các ngành học phù hợp, điểm chuẩn và trường Đại học tương ứng!',
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
                    'Làm lại trắc nghiệm',
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

    final q = _questions[_currentQ];
    final options = q['options'] as List;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: (_currentQ + 1) / _questions.length,
            color: const Color(0xFF6366F1),
            backgroundColor: isDark
                ? const Color(0xFF1E293B)
                : const Color(0xFFE2E8F0),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Câu ${_currentQ + 1} / ${_questions.length}',
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
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF6366F1),
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
