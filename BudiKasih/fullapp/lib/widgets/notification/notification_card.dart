import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = item['isRead'] as bool;
    final bgColor = isRead ? Colors.white : Colors.blue.shade50;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: bgColor.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead ? Colors.grey[200]! : AppColors.primaryBlue.withOpacity(0.3),
            width: isRead ? 1 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (item['iconColor'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item['icon'],
                color: item['iconColor'],
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['msg'], style: AppTextStyles.body.copyWith(fontSize: 14, height: 1.5, color: Colors.black87, fontWeight: isRead ? FontWeight.normal : FontWeight.w600)),
                  if (!isRead) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('BARU', style: AppTextStyles.body.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red.shade700)),
                        ),
                        const SizedBox(width: 8),
                        Text('Ketuk untuk detail', style: AppTextStyles.body.copyWith(fontSize: 11, color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20)
          ],
        ),
      ),
    );
  }
}