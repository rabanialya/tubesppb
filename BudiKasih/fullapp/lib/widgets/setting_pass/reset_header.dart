import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../themes/text_styles.dart';

class ResetHeader extends StatelessWidget {
  final String subtitle;

  const ResetHeader({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.lock_reset,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),

        Text(
          'Reset Password',
          style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white,)
        ),
        const SizedBox(height: 8),

        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white.withOpacity(0.8), height: 1.4,),
        ),
      ],
    );
  }
}