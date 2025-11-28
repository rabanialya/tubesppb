import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';
import '../auth/custom_text_field.dart';

class StepVerification extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onNext;
  final VoidCallback onResend;

  const StepVerification({
    super.key,
    required this.controller,
    required this.onNext,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kode Verifikasi',
          style: AppTextStyles.body.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: controller,
          hint: '000000',
          icon: Icons.pin_outlined,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tidak menerima kode? ',
              style: AppTextStyles.body.copyWith(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            GestureDetector(
              onTap: onResend,
              child: Text(
                'Kirim Ulang',
                style: AppTextStyles.body.copyWith(
                  fontSize: 13,
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Verifikasi',
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}