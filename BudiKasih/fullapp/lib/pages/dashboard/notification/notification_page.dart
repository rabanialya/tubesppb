import 'package:flutter/material.dart';
import '../../../widgets/top_header.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../../widgets/bg_container.dart';
import '../../../widgets/donation_modal.dart';
import '../../../themes/colors.dart';
import '../../../themes/text_styles.dart';
import '../../../widgets/notification/filter_modal.dart';
import '../../../widgets/notification/notification_card.dart';
import '../../../widgets/notification/notification_detail_dialog.dart';
import '../../../widgets/notification/empty_state.dart';
import '../../../widgets/notification/section_list.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String selectedFilter = 'Semua';
  int currentIndex = 0;

  // ===================== BOTTOM NAV =====================
  void _onNavTap(int index) {
    setState(() => currentIndex = index);

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      showDonationModal(context);
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  // ===================== FILTER MODAL =====================
  void _showFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => NotificationFilterModal(
        selectedFilter: selectedFilter,
        onSelected: (value) {
          setState(() => selectedFilter = value);
        },
      ),
    );
  }

  // ===================== SHOW DETAIL =====================
  dynamic _openDetail(Map<dynamic, dynamic> item) {
    // tandai sudah dibaca
    setState(() => item['isRead'] = true);

    return showDialog(
      context: context,
      builder: (_) => NotificationDetailDialog(data: Map<String, dynamic>.from(item)),
    );
  }

  // ===================== DATA (SAMA PERSIS DGN ASLI) =====================
  final List<Map<String, dynamic>> notifications = [
    {
      'date': 'Hari ini, 08/11/25',
      'items': [
        {
          'msg': 'Terima kasih! Donasi tunai Anda telah diterima pihak panti ❤️',
          'isRead': true,
          'icon': Icons.check_circle_outline,
          'iconColor': Colors.green,
          'type': 'cash_verified',
          'detail': {
            'amount': 'Rp 500.000',
            'method': 'Transfer Bank BCA',
            'date': '08/11/2025'
          }
        },
        {
          'msg': 'Panti sedang membutuhkan susu lansia dan vitamin. Mari bantu!',
          'isRead': false,
          'icon': Icons.volunteer_activism,
          'iconColor': AppColors.primaryBlue,
          'type': 'urgent_need',
          'detail': {
            'item': 'Susu Lansia & Vitamin',
            'needed': '10 box',
          }
        },
      ]
    },
    {
      'date': 'Kemarin, 07/11/25',
      'items': [
        {
          'msg': 'Pesan Anda untuk Oma Rini sudah diterima 🕊️',
          'isRead': true,
          'icon': Icons.mail_outline,
          'iconColor': Colors.green,
          'type': 'message_received',
          'detail': {
            'recipient': 'Oma Rini',
            'date': '07/11/2025',
            'message': 'Semangat Oma Rini! Semoga selalu sehat dan bahagia 💕'
          }
        },
      ]
    },
    {
      'date': '05/11/25',
      'items': [
        {
          'msg':
              'Donasi barang berupa Pampers telah sampai di panti. Terima kasih atas kebaikan Anda! 💝',
          'isRead': true,
          'icon': Icons.local_shipping_outlined,
          'iconColor': Colors.green,
          'type': 'donation_received',
          'detail': {
            'donorName': 'Isabell Conklin',
            'type': 'Donasi Barang',
            'item': 'Pampers Dewasa Size L',
            'quantity': '5 bungkus',
            'date': '05/11/2025'
          }
        },
      ]
    },
  ];

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Notifikasi', style: AppTextStyles.titleWhite.copyWith(fontSize: 18)),
        actions: [
          IconButton(
            onPressed: _showFilter,
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        onTap: _onNavTap,
      ),

      body: BackgroundContainer(
        child: notifications.isEmpty
            ? Center(child: Text('Belum ada notifikasi', style: AppTextStyles.body.copyWith(fontSize: 14, color: Colors.black54)))
            : NotificationSectionList(
                sections: notifications,
                filter: selectedFilter,
                onCardTap: _openDetail,
              ),
      ),
    );
  }
}