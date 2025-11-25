import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../themes/text_styles.dart';

class HomeWelcomeCard extends StatelessWidget {
  const HomeWelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.waving_hand, color: AppColors.primaryBlue, size: 28),
              const SizedBox(width: 10),
              Text('Halo, Sahabat BudiKasih!', style: AppTextStyles.heading.copyWith(fontSize: 20, color: AppColors.darkBlue)),
            ],
          ),
          const SizedBox(height: 12),
          Text('Terima kasih sudah peduli pada kebahagiaan lansia. Mari bantu wujudkan masa tua yang penuh cinta dan ketenangan 🌼', style: AppTextStyles.body.copyWith(color: AppColors.darkBlue, fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }
}