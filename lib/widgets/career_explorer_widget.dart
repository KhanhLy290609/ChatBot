import 'package:flutter/material.dart';
import '../models/career_model.dart';

class CareerExplorerWidget extends StatelessWidget {
  final Function(String) onAskAI;
  final List<CareerModel> careers;
  final Color primaryColor;
  final String language;

  const CareerExplorerWidget({
    super.key,
    required this.onAskAI,
    this.careers = defaultCareers,
    this.primaryColor = const Color(0xFF6366F1),
    this.language = 'vi',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == 'en';

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
                      c.getTitle(language),
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      isEn ? 'Block ${c.block}' : 'Khối ${c.block}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                c.getDesc(language),
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
                    isEn
                        ? 'Reference Salary: ${c.getSalary(language)}'
                        : 'Lương tham khảo: ${c.getSalary(language)}',
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
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: Text(
                  isEn ? 'Ask AI About This Major' : 'Hỏi AI Chi Tiết Ngành Này',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  onAskAI(
                    isEn
                        ? 'Please advise in detail about **${c.getTitle(language)}** (Block ${c.block}): Benchmark scores, top universities, and career opportunities!'
                        : 'Nhờ EduPath AI tư vấn chi tiết về ngành **${c.getTitle(language)}** (Khối ${c.block}): Điểm chuẩn, các trường ĐH top đầu và cơ hội việc làm!',
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
