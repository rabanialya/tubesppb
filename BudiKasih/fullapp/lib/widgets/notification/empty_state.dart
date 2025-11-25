import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';
import 'notification_card.dart';

class NotificationSectionList extends StatelessWidget {
  final List<Map<String, dynamic>> sections;
  final String filter;
  final Function(Map item) onCardTap;

  const NotificationSectionList({
    super.key,
    required this.sections,
    required this.filter,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sections.length,
      itemBuilder: (context, sectionIndex) {
        final section = sections[sectionIndex];

        final filteredItems = (section['items'] as List).where((item) {
          if (filter == 'Belum Dibaca') return !(item['isRead'] as bool);
          if (filter == 'Sudah Dibaca') return item['isRead'] as bool;
          return true;
        }).toList();

        if (filteredItems.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title date
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(section['date'], style: AppTextStyles.heading.copyWith(fontSize: 15, color: AppColors.darkBlue)),
            ),

            ...filteredItems.map((item) {
              return NotificationCard(
                item: item,
                onTap: () => onCardTap(item),
              );
            }),

            if (sectionIndex < sections.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(color: Colors.grey[300]),
              )
          ],
        );
      },
    );
  }
}