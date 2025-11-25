import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

class InfoDialog {
  static void show(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.info_outline,
                  size: 24, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 12),
            Text(title, style: AppTextStyles.heading.copyWith(fontSize: 18, color: AppColors.darkBlue)),
          ],
        ),
        content: Text(content, style: AppTextStyles.body.copyWith(fontSize: 14, color: Colors.black87, height: 1.6)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup', style: AppTextStyles.body),
          ),
        ],
      ),
    );
  }
}