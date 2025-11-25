import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../themes/text_styles.dart';

class DonationMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onChange;

  const DonationMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab('Transfer Bank', 'transfer', Icons.account_balance),
          ),
          Expanded(
            child: _buildTab('QRIS', 'qris', Icons.qr_code_2),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, String value, IconData icon) {
    final bool isSelected = selectedMethod == value;
    return GestureDetector(
      onTap: () => onChange(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? AppColors.primaryBlue : Colors.grey[600], size: 20),
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.body.copyWith(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primaryBlue : Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}