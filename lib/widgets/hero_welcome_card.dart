import 'package:flutter/material.dart';

class HeroWelcomeCard extends StatelessWidget {
  const HeroWelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
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
              : const Color(0xFFE9D5FF).withValues(alpha: 0.8),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xin chào! Mình là\nEduPath AI',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: isDark ? const Color(0xFFA78BFA) : const Color(0xFF5B46E0),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Người bạn đồng hành thông minh giúp bạn khám phá bản thân, lựa chọn ngành học và xây dựng lộ trình sự nghiệp mơ ước. Hãy đặt bất kỳ câu hỏi nào nhé!',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.grey.shade300 : const Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }
}
