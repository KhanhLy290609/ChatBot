import 'package:flutter/material.dart';

class FloatingBottomDock extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTapTab;
  final Color primaryColor;
  final String language;

  const FloatingBottomDock({
    super.key,
    required this.currentIndex,
    required this.onTapTab,
    this.primaryColor = const Color(0xFF6366F1),
    this.language = 'vi',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == 'en';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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
            icon: Icons.chat_bubble_outline,
            activeIcon: Icons.chat_bubble,
            label: 'Chat',
            isDark: isDark,
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.psychology_outlined,
            activeIcon: Icons.psychology,
            label: isEn ? 'Holland' : 'Holland',
            isDark: isDark,
          ),
          _buildNavItem(
            index: 2,
            icon: Icons.work_outline,
            activeIcon: Icons.work,
            label: isEn ? 'Careers' : 'Ngành Hot',
            isDark: isDark,
          ),
          _buildNavItem(
            index: 3,
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: isEn ? 'Profile' : 'Cá Nhân',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
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
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 8)
            : const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 18,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey.shade400 : const Color(0xFF475569)),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ] else ...[
              const SizedBox(width: 3),
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : const Color(0xFF475569),
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
