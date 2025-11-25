import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

class LogoutDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red.shade600, size: 28),
            const SizedBox(width: 12),
            Text('Konfirmasi Logout', style: AppTextStyles.heading.copyWith(fontSize: 18, color: AppColors.darkBlue)),
          ],
        ),
        content: Text('Apakah Anda yakin ingin keluar dari akun?', style: AppTextStyles.body.copyWith(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: AppTextStyles.body),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: Text('Logout', style: AppTextStyles.body.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}