import 'package:flutter/material.dart';

class HeroWelcomeCard extends StatelessWidget {
  final Color primaryColor;
  final String language;

  const HeroWelcomeCard({
    super.key,
    this.primaryColor = const Color(0xFF6366F1),
    this.language = 'vi',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == 'en';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  primaryColor.withValues(alpha: 0.3),
                  primaryColor.withValues(alpha: 0.15),
                ]
              : [
                  primaryColor.withValues(alpha: 0.06),
                  primaryColor.withValues(alpha: 0.14),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: primaryColor.withValues(alpha: isDark ? 0.4 : 0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'Hello! I am\nEduPath AI' : 'Xin chào! Mình là\nEduPath AI',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: primaryColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isEn
                ? 'Your smart AI companion helping you explore yourself, choose university majors, and build your dream career path. Feel free to ask any question!'
                : 'Người bạn đồng hành thông minh giúp bạn khám phá bản thân, lựa chọn ngành học và xây dựng lộ trình sự nghiệp mơ ước. Hãy đặt bất kỳ câu hỏi nào nhé!',
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
