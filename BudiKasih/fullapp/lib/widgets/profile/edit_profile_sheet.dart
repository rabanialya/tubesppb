import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

class EditProfileSheet extends StatelessWidget {
  final TextEditingController nameC;
  final TextEditingController emailC;
  final TextEditingController passwordC;

  const EditProfileSheet({
    super.key,
    required this.nameC,
    required this.emailC,
    required this.passwordC,
  });

  Widget _field(String label, IconData icon, TextEditingController c,
      {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryBlue, size: 18),
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkBlue)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: c,
          obscureText: obscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primaryBlue, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.edit, color: AppColors.primaryBlue, size: 26),
                const SizedBox(width: 12),
                Text('Edit Profil', style: AppTextStyles.heading.copyWith(fontSize: 20, color: AppColors.darkBlue)),
              ],
            ),
            const SizedBox(height: 24),

            _field('Nama Lengkap', Icons.person_outline, nameC),
            const SizedBox(height: 16),
            _field('Email', Icons.mail_outline, emailC),
            const SizedBox(height: 16),
            _field('Password Baru', Icons.lock_outline, passwordC, obscure: true),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Simpan Perubahan', style: AppTextStyles.body.copyWith(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}