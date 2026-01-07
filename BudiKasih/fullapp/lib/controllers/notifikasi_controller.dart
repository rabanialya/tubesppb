// lib/controllers/notification_controller.dart

import 'package:flutter/material.dart';
import '../models/notifikasi_model.dart';
import '../services/notifikasi_service.dart';

class NotificationController extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  List<NotificationSection> _allNotifications = [];
  List<NotificationSection> _filteredNotifications = [];
  String _selectedFilter = 'Semua';
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<NotificationSection> get notifications => _filteredNotifications;
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get unreadCount => _service.getUnreadCount(_allNotifications);
  bool get hasNotifications => _allNotifications.isNotEmpty;

  // Load notifications
  Future<void> loadNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allNotifications = await _service.fetchNotifications();
      _applyFilter();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat notifikasi: $e';
      notifyListeners();
    }
  }

  // Add donation notification - FIXED VERSION
  Future<void> addDonationNotification({
    required int amount,
    required String paymentMethod,
    String? transactionId,
  }) async {
    try {
      final now = DateTime.now();
      final today = 'Hari Ini';
      
      // Format rupiah
      final formattedAmount = _formatRupiah(amount);

      final newNotif = NotificationModel(
        msg: 'Donasi Anda sebesar $formattedAmount telah diterima',
        isRead: false,
        icon: Icons.volunteer_activism,
        iconColor: Colors.green,
        type: 'donation',
        detail: 'Terima kasih atas donasi Anda melalui $paymentMethod. '
                'Dana akan digunakan untuk kebutuhan harian para lansia '
                'di Panti Wredha Budi Dharma Kasih.\n\n'
                'Waktu: ${_formatDateTime(now)}',
      );

      // Cek apakah sudah ada section "Hari Ini"
      final todayIndex = _allNotifications.indexWhere(
        (section) => section.date == today
      );
      
      if (todayIndex != -1) {
        // Tambahkan ke section yang sudah ada (di paling atas)
        _allNotifications[todayIndex].items.insert(0, newNotif);
      } else {
        // Buat section baru di paling atas
        _allNotifications.insert(0, NotificationSection(
          date: today,
          items: [newNotif],
        ));
      }

      // Apply filter dan update UI
      _applyFilter();
      notifyListeners(); // Ini yang penting - harus dipanggil

      // Simpan ke backend jika perlu
      try {
        await _service.saveDonationNotification(amount, paymentMethod);
      } catch (e) {
        debugPrint('Failed to save notification to backend: $e');
        // Tetap lanjutkan, karena notifikasi sudah ditambahkan ke UI
      }

    } catch (e) {
      debugPrint('Error adding donation notification: $e');
      // Jangan throw error agar UI tidak crash
    }
  }

  // Helper method untuk format rupiah
  String _formatRupiah(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  String _formatDateTime(DateTime dateTime) {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];

    final day = days[dateTime.weekday % 7];
    final date = dateTime.day;
    final month = months[dateTime.month - 1];
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day, $date $month $year - $hour:$minute WIB';
  }

  // Set filter
  void setFilter(String filter) {
    _selectedFilter = filter;
    _applyFilter();
    notifyListeners();
  }

  // Apply filter
  void _applyFilter() {
    _filteredNotifications = _service.filterByType(
      _allNotifications,
      _selectedFilter,
    );
  }

  // Mark as read
  Future<void> markAsRead(NotificationSection section, NotificationModel item) async {
    if (item.isRead) return;

    // Update UI immediately
    final sectionIndex = _allNotifications.indexOf(section);
    if (sectionIndex != -1) {
      final itemIndex = _allNotifications[sectionIndex].items.indexOf(item);
      if (itemIndex != -1) {
        _allNotifications[sectionIndex].items[itemIndex] = 
            item.copyWith(isRead: true);
        _applyFilter();
        notifyListeners();
      }
    }

    // Update backend
    try {
      await _service.markAsRead(item.type);
    } catch (e) {
      debugPrint('Failed to mark as read: $e');
    }
  }

  // Refresh notifications
  Future<void> refresh() async {
    await loadNotifications();
  }
}