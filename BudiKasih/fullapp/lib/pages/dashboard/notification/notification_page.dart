import 'package:flutter/material.dart';

import '../../../themes/app_theme.dart';
import '../../../themes/colors.dart';
import '../../../themes/text_styles.dart';

import '../../../widgets/reusable/top_header.dart';
import '../../../widgets/reusable/app_bottom_nav.dart';
import '../../../widgets/reusable/bg_container.dart';
import '../../../widgets/donation/donation_modal.dart';
import '../../../widgets/notification/filter_modal.dart';
import '../../../widgets/notification/notification_card.dart';
import '../../../widgets/notification/notification_detail_dialog.dart';
import '../../../widgets/notification/empty_state.dart';
import '../../../widgets/notification/section_list.dart';

import '../../../controllers/notifikasi_controller.dart';
import '../../../models/notifikasi_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int currentIndex = 0;
  late NotificationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NotificationController();
    _controller.loadNotifications();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

  void _showFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => NotificationFilterModal(
        selectedFilter: _controller.selectedFilter,
        onSelected: (value) {
          setState(() {
            _controller.setFilter(value);
          });
        },
      ),
    );
  }

  dynamic _openDetail(Map<dynamic, dynamic> item) {
    // Cari section dan item yang sesuai
    for (var section in _controller.notifications) {
      for (var notifItem in section.items) {
        if (notifItem.msg == item['msg']) {
          _controller.markAsRead(section, notifItem);
          break;
        }
      }
    }

    return showDialog(
      context: context,
      builder: (_) => NotificationDetailDialog(data: Map<String, dynamic>.from(item)),
    );
  }

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
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (_controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_controller.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _controller.errorMessage!,
                      style: AppTextStyles.body.copyWith(fontSize: 14, color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _controller.refresh,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            if (!_controller.hasNotifications) {
              return Center(
                child: Text(
                  'Belum ada notifikasi',
                  style: AppTextStyles.body.copyWith(fontSize: 14, color: Colors.black54),
                ),
              );
            }

            // Convert ke format yang dibutuhkan NotificationSectionList
            final sections = _controller.notifications.map((section) {
              return {
                'date': section.date,
                'items': section.items.map((item) {
                  return {
                    'msg': item.msg,
                    'isRead': item.isRead,
                    'icon': item.icon,
                    'iconColor': item.iconColor,
                    'type': item.type,
                    'detail': item.detail,
                  };
                }).toList(),
              };
            }).toList();

            return NotificationSectionList(
              sections: sections,
              filter: _controller.selectedFilter,
              onCardTap: _openDetail,
            );
          },
        ),
      ),
    );
  }
}