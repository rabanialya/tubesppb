import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

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
          Text('Dengan penuh rasa syukur dan sukacita, kami dari Panti Wredha Budi Dharma Kasih Purbalingga menyambut kehadiran Anda. Aplikasi ini kami hadirkan sebagai jembatan kasih antara Anda dan para Oma & Opa yang kami rawat dengan penuh perhatian. Terima kasih telah menjadi bagian dari keluarga besar BudiKasih. Mari bersama menebarkan cinta, merawat harapan, dan menghadirkan senyum untuk para Oma & Opa 💐', textAlign: TextAlign.justify,),
        ],
      ),
    );
  }
}