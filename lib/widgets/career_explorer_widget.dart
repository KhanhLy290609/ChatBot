import 'package:flutter/material.dart';
import '../models/career_model.dart';

class CareerExplorerWidget extends StatelessWidget {
  final Function(String) onAskAI;
  final List<CareerModel> careers;

  const CareerExplorerWidget({
    super.key,
    required this.onAskAI,
    this.careers = defaultCareers,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: careers.length,
      itemBuilder: (ctx, idx) {
        final c = careers[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        c.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text('Khối ${c.block}'),
                      backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
                    )
                  ],
                ),
                Text(
                  c.desc,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lương tham khảo: ${c.salary}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.auto_awesome, size: 18),
                  label: const Text('Hỏi AI Chi Tiết Ngành Này'),
                  onPressed: () {
                    onAskAI(
                      'Nhờ EduPath AI tư vấn chi tiết về ngành **${c.title}** (Khối ${c.block}): Điểm chuẩn, các trường ĐH top đầu và cơ hội việc làm!',
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
