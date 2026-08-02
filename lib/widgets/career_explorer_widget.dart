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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: careers.length,
      itemBuilder: (ctx, idx) {
        final c = careers[idx];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      c.title,
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? const Color(0xFFA78BFA)
                            : const Color(0xFF5B46E0),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      'Khối ${c.block}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                c.desc,
                style: TextStyle(
                  fontSize: 13.5,
                  color: isDark ? Colors.grey.shade300 : const Color(0xFF475569),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.payments_outlined,
                      size: 16, color: Colors.green),
                  const SizedBox(width: 6),
                  Text(
                    'Lương tham khảo: ${c.salary}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: const Text(
                  'Hỏi AI Chi Tiết Ngành Này',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  onAskAI(
                    'Nhờ EduPath AI tư vấn chi tiết về ngành **${c.title}** (Khối ${c.block}): Điểm chuẩn, các trường ĐH top đầu và cơ hội việc làm!',
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
