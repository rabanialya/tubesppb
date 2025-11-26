import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';
import '../custom_text_field.dart';

class StepNewPassword extends StatelessWidget {
  final TextEditingController newPass;
  final TextEditingController confirmPass;
  final bool obscureNew;
  final bool obscureConfirm;
  final VoidCallback onToggleNew;
  final VoidCallback onToggleConfirm;
  final VoidCallback onSubmit;

  const StepNewPassword({
    super.key,
    required this.newPass,
    required this.confirmPass,
    required this.obscureNew,
    required this.obscureConfirm,
    required this.onToggleNew,
    required this.onToggleConfirm,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password Baru',
          style: AppTextStyles.body.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 8),

        CustomTextField(
          controller: newPass,
          hint: 'Minimal 6 karakter',
          icon: Icons.lock_outline,
          obscure: obscureNew,
          suffixIcon: IconButton(
            icon: Icon(
              obscureNew
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey[600],
            ),
            onPressed: onToggleNew,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Konfirmasi Password',
          style: AppTextStyles.body.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 8),

        CustomTextField(
          controller: confirmPass,
          hint: 'Ulangi password baru',
          icon: Icons.lock_outline,
          obscure: obscureConfirm,
          suffixIcon: IconButton(
            icon: Icon(
              obscureConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey[600],
            ),
            onPressed: onToggleConfirm,
          ),
        ),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Simpan Perubahan',
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}