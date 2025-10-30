import 'package:flutter/material.dart';
import '../themes/colors.dart';

class TopHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotification;
  final VoidCallback? onBack;
  final bool showBack;

  const TopHeader({super.key, this.onNotification, this.onBack, this.showBack = false});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryBlue,
      elevation: 0,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBack ?? () => Navigator.pop(context),
            )
          : const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(Icons.church, color: Colors.white),
            ),
      title: Container(
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Cari sesuatu...',
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: onNotification,
          icon: const Icon(Icons.notifications, color: Colors.white),
        ),
      ],
    );
  }
}