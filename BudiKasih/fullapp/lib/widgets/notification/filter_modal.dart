import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

class NotificationFilterModal extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  const NotificationFilterModal({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text('Filter Notifikasi', style: AppTextStyles.heading.copyWith(fontSize: 18, color: AppColors.darkBlue)),
            const SizedBox(height: 20),

            // Options
            _option(context, 'Semua', Icons.notifications),
            _option(context, 'Belum Dibaca', Icons.mark_email_unread),
            _option(context, 'Sudah Dibaca', Icons.mark_email_read),
          ],
        ),
      ),
    );
  }

  Widget _option(BuildContext context, String label, IconData icon) {
    final isSelected = selectedFilter == label;

    return InkWell(
      onTap: () {
        onSelected(label);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 22,
                color: isSelected ? AppColors.primaryBlue : Colors.grey[600]),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.body.copyWith(fontSize: 15, color: isSelected ? AppColors.primaryBlue : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryBlue, size: 20)
          ],
        ),
      ),
    );
  }
}