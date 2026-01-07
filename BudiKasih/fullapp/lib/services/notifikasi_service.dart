// lib/services/notifikasi_service.dart

import 'package:flutter/material.dart';
import '../models/notifikasi_model.dart';

class NotificationService {
  // Fetch notifications from backend
  Future<List<NotificationSection>> fetchNotifications() async {
    // Simulasi delay network
    await Future.delayed(const Duration(milliseconds: 500));

    // Data dummy - ganti dengan API call yang sebenarnya
    return [
      NotificationSection(
        date: 'Hari Ini',
        items: [
          NotificationModel(
            msg: 'Selamat datang di Aplikasi Budi Kasih!',
            isRead: false,
            icon: Icons.celebration,
            iconColor: Colors.orange,
            type: 'info',
            detail: 'Terima kasih telah bergabung dengan kami dalam membantu para lansia.',
          ),
        ],
      ),
    ];
  }

  // Save donation notification to backend
  Future<void> saveDonationNotification(int amount, String paymentMethod) async {
    try {
      // TODO: Implementasi API call ke backend
      // Example:
      // final response = await http.post(
      //   Uri.parse('$baseUrl/api/notifications/donation'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({
      //     'amount': amount,
      //     'payment_method': paymentMethod,
      //     'timestamp': DateTime.now().toIso8601String(),
      //   }),
      // );
      
      await Future.delayed(const Duration(milliseconds: 300));
      debugPrint('Donation notification saved: Rp$amount via $paymentMethod');
    } catch (e) {
      debugPrint('Error saving donation notification: $e');
      rethrow;
    }
  }

  // Filter notifications by type
  List<NotificationSection> filterByType(
    List<NotificationSection> sections,
    String filter,
  ) {
    if (filter == 'Semua') {
      return sections;
    }

    return sections.map((section) {
      final filteredItems = section.items.where((item) {
        if (filter == 'Donasi') return item.type == 'donation';
        if (filter == 'Info') return item.type == 'info';
        if (filter == 'Belum Dibaca') return !item.isRead;
        return true;
      }).toList();

      return NotificationSection(
        date: section.date,
        items: filteredItems,
      );
    }).where((section) => section.items.isNotEmpty).toList();
  }

  // Get unread count
  int getUnreadCount(List<NotificationSection> sections) {
    int count = 0;
    for (var section in sections) {
      count += section.items.where((item) => !item.isRead).length;
    }
    return count;
  }

  // Mark as read
  Future<void> markAsRead(String type) async {
    try {
      // TODO: Implementasi API call ke backend
      // Example:
      // await http.put(
      //   Uri.parse('$baseUrl/api/notifications/mark-read'),
      //   body: {'type': type},
      // );
      
      await Future.delayed(const Duration(milliseconds: 200));
      debugPrint('Notification marked as read: $type');
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      rethrow;
    }
  }
}