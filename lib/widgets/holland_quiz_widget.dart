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
    if (_currentQ >= _questions.length) {
      final counts = <String, int>{'R': 0, 'I': 0, 'A': 0, 'S': 0, 'E': 0, 'C': 0};
      for (final type in _answers.values) {
        counts[type] = (counts[type] ?? 0) + 1;
      }
      final sorted = counts.keys.toList()
        ..sort((a, b) => counts[b]!.compareTo(counts[a]!));
      final topType = sorted.first;

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Color(0xFF6366F1)),
            const SizedBox(height: 16),
            Text(
              'Kết quả Holland của bạn: Mã $topType',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Nhấp nút bên dưới để chuyển kết quả sang Chatbot AI phân tích ngành học và trường ĐH phù hợp!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              icon: const Icon(Icons.send),
              label: const Text('Gửi Cho AI Tư Vấn Ngành Cụ Thể'),
              onPressed: () {
                widget.onSendToChat(
                  'Tớ vừa hoàn thành bài trắc nghiệm Holland và có kết quả nhóm nổi bật nhất là mã $topType. Nhờ EduPath AI tư vấn cụ thể các ngành học phù hợp!',
                );
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentQ = 0;
                  _answers.clear();
                });
              },
              child: const Text('Làm lại trắc nghiệm'),
            )
          ],
        ),
      );
    }

    final q = _questions[_currentQ];
    final options = q['options'] as List;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: (_currentQ + 1) / _questions.length,
            color: const Color(0xFF6366F1),
          ),
          const SizedBox(height: 20),
          Text(
            q['question'] as String,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (ctx, idx) {
                final opt = options[idx] as Map<String, dynamic>;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.centerLeft,
                    ),
                    onPressed: () {
                      setState(() {
                        _answers[_currentQ] = opt['type'] as String;
                        _currentQ++;
                      });
                    },
                    child: Text(
                      opt['text'] as String,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
