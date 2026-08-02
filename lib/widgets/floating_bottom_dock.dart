import 'package:flutter/material.dart';

class FloatingBottomDock extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTapTab;

  const FloatingBottomDock({
    super.key,
    required this.currentIndex,
    required this.onTapTab,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.chat_bubble,
            label: 'Chat',
            isDark: isDark,
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.psychology_outlined,
            label: 'Holland Test',
            isDark: isDark,
          ),
          _buildNavItem(
            index: 2,
            icon: Icons.work_outline,
            label: 'Careers',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    final isSelected = currentIndex == index;

    return InkWell(
      onTap: () => onTapTab(index),
      borderRadius: BorderRadius.circular(40.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 18, vertical: 10)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF6366F1) : const Color(0xFF6366F1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey.shade400 : const Color(0xFF475569)),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ] else ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : const Color(0xFF475569),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
