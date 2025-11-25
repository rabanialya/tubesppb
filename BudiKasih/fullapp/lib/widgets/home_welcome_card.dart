import 'package:flutter/material.dart';
import '../themes/colors.dart';

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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.waving_hand, color: AppColors.primaryBlue, size: 28),
              SizedBox(width: 10),
              Text(
                'Halo, Sahabat BudiKasih!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Terima kasih sudah peduli pada kebahagiaan lansia. Mari bantu wujudkan masa tua yang penuh cinta dan ketenangan 🌼',
            style: TextStyle(
              color: AppColors.darkBlue,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}