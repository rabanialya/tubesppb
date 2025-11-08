import 'package:flutter/material.dart';
import '../themes/colors.dart';

class TopHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotification;
  final VoidCallback? onBack;
  final bool showBack;

  const TopHeader({
    super.key,
    this.onNotification,
    this.onBack,
    this.showBack = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryBlue,
      elevation: 0,
      leadingWidth: 60,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBack ?? () => Navigator.pop(context),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 12),
              child: SizedBox(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/img/logopanti.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
      title: Container(
        height: 40,
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
        const SizedBox(width: 8),
      ],
    );
  }
}