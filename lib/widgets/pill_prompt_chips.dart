import 'package:flutter/material.dart';

class PillPromptChips extends StatelessWidget {
  final Function(String) onPromptSelected;
  final Color primaryColor;

  const PillPromptChips({
    super.key,
    required this.onPromptSelected,
    this.primaryColor = const Color(0xFF6366F1),
  });

  static const List<String> _prompts = [
    'Tôi giỏi Toán và Lý',
    'Khối A01 học ngành gì?',
    'AI có phù hợp với mình?',
    'Ngành hot 2026',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _prompts.map((text) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onPromptSelected(text),
              borderRadius: BorderRadius.circular(50.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: isDark ? 0.35 : 0.25),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
