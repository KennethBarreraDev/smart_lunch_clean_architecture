import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';

class SettingsOptionCard extends StatelessWidget {
  const SettingsOptionCard({
    super.key,
    required this.icon,
    required this.text,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String text;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        width: 100.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.coral, size: 26),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Comfortaa",
                  color: Color(0xFF333333),
                ),
              ),
            ),
            const SizedBox(width: 12),
            trailing,
          ],
        ),
      ),
    );
  }
}
