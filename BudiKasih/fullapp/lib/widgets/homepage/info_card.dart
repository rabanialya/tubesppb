import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryBlue),
              const SizedBox(width: 10),
              Text(title, style: AppTextStyles.heading.copyWith(fontSize: 16, color: AppColors.darkBlue)),
            ],
          ),
          const SizedBox(height: 10),
          Text(content, textAlign: TextAlign.justify, style: AppTextStyles.body.copyWith(height: 1.5, color: Colors.black87, fontSize: 14)),
        ],
      ),
    );
  }
}