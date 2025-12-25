import 'package:flutter/material.dart';
import 'notification_card.dart';

class NotificationList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final void Function(Map<String,dynamic>)? onTapItem;

  const NotificationList({super.key, required this.items, this.onTapItem});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: items.map((it) {
        return NotificationCard(
          item: it,
          onTap: () => onTapItem?.call(it),
        );
      }).toList(),
    );
  }
}