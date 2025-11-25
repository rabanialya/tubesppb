import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../themes/text_styles.dart';

class TransferBankCard extends StatelessWidget {
  final String bank;
  final String number;
  final String name;
  final VoidCallback onCopy;

  const TransferBankCard({
    super.key,
    required this.bank,
    required this.number,
    required this.name,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryBlue.withOpacity(0.1), Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(bank, style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const Spacer(),
              IconButton(
                onPressed: onCopy,
                icon: Icon(Icons.copy, color: AppColors.primaryBlue, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(number, style: AppTextStyles.heading.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkBlue, letterSpacing: 1.2)),
          const SizedBox(height: 6),
          Text('A.n. $name', style: AppTextStyles.body.copyWith(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }
}