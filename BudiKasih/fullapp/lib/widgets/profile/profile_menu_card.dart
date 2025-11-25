import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

class ProfileMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;

  const ProfileMenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primaryBlue).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon,
                  color: iconColor ?? AppColors.primaryBlue, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title, style: AppTextStyles.body.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}