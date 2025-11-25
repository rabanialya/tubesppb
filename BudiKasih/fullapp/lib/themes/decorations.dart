import 'package:flutter/material.dart';
import 'colors.dart';

class AppDecorations {
  // White card with shadow
  static BoxDecoration whiteCard({double radius = 16, double opacity = 0.95}) {
    return BoxDecoration(
      color: Colors.white.withOpacity(opacity),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Gradient card (blue gradient)
  static BoxDecoration gradientBlueCard({double radius = 16}) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.primaryBlue, AppColors.primaryBlue.withOpacity(0.8)],
      ),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryBlue.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Gradient card (green gradient)
  static BoxDecoration gradientGreenCard({double radius = 16}) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.green.shade600, Colors.green.shade700],
      ),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.green.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Icon container background
  static BoxDecoration iconContainer({
    required Color color,
    double radius = 12,
    double opacity = 0.1,
  }) {
    return BoxDecoration(
      color: color.withOpacity(opacity),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  // Circle icon container with border
  static BoxDecoration circleIconContainer({
    required Color color,
    double opacity = 0.1,
    Color? borderColor,
    double borderWidth = 2,
  }) {
    return BoxDecoration(
      color: color.withOpacity(opacity),
      shape: BoxShape.circle,
      border: Border.all(
        color: borderColor ?? color.withOpacity(0.3),
        width: borderWidth,
      ),
    );
  }

  // Form field background decoration
  static BoxDecoration formFieldBackground({double radius = 12}) {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Card with colored border
  static BoxDecoration borderedCard({
    required Color borderColor,
    double radius = 16,
    double borderWidth = 1.5,
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Notification card decoration
  static BoxDecoration notificationCard({
    required bool isRead,
    double radius = 16,
  }) {
    final bgColor = isRead ? Colors.white : Colors.blue.shade50;
    final borderColor = isRead ? Colors.grey[200]! : AppColors.primaryBlue.withOpacity(0.3);
    final borderWidth = isRead ? 1.0 : 1.5;

    return BoxDecoration(
      color: bgColor.withOpacity(0.95),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Menu item decoration
  static BoxDecoration menuItem({
    bool isSelected = false,
    double radius = 12,
  }) {
    return BoxDecoration(
      color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : Colors.grey[50],
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: isSelected ? AppColors.primaryBlue : Colors.grey[200]!,
        width: isSelected ? 2 : 1,
      ),
    );
  }

  // Profile header gradient
  static BoxDecoration profileHeaderGradient({double radius = 20}) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.primaryBlue, AppColors.primaryBlue.withOpacity(0.8)],
      ),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryBlue.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  // Bank card decoration with gradient
  static BoxDecoration bankCard({double radius = 12}) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.primaryBlue.withOpacity(0.1), Colors.blue.shade50],
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
    );
  }

  // Image picker container
  static BoxDecoration imagePickerContainer({double radius = 12}) {
    return BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.grey[300]!, width: 2),
    );
  }

  // Modal handle decoration
  static BoxDecoration modalHandle() {
    return BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(2),
    );
  }

  // Info box decoration
  static BoxDecoration infoBox({required Color color, double radius = 10}) {
    return BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  // Priority badge decoration
  static BoxDecoration priorityBadge({required Color color, double radius = 20}) {
    return BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  // Wallet icon decoration
  static BoxDecoration walletIcon({required Color color, double radius = 8}) {
    return BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: color.withOpacity(0.3)),
    );
  }
}