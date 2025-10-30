import 'package:flutter/material.dart';
import '../../../widgets/top_header.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../../themes/colors.dart';
import '../../../themes/text_styles.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String selectedFilter = 'Semua';
  int _selectedIndex = 1;

  void _onNavTap(int index) {
    if (index == 0) Navigator.pushReplacementNamed(context, '/home');
    if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
        _filterOption('Semua'),
        _filterOption('Belum Dibaca'),
        _filterOption('Sudah Dibaca'),
      ]),
    );
  }

  Widget _filterOption(String text) {
    return ListTile(
      title: Center(
        child: Text(
          text,
          style: TextStyle(
            color: selectedFilter == text ? AppColors.primaryBlue : AppColors.darkBlue,
            fontWeight: selectedFilter == text ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
      onTap: () {
        setState(() => selectedFilter = text);
        Navigator.pop(context);
      },
    );
  }

  final List<Map<String, dynamic>> notifications = [
    {
      'date': 'Hari ini, 23/10/25',
      'items': [
        {'msg': 'Donasi barang berupa minyak kayu putih telah diterima pihak panti.', 'color': Color(0xFFDCEAFB)},
        {'msg': 'Donasi anda sedang diproses, pihak panti akan mengirimkan prosedur pengiriman.', 'color': Color(0xFFEAF8EA)},
      ]
    },
    {
      'date': 'Kemarin, 22/10/25',
      'items': [
        {'msg': 'Ketersediaan underpad untuk oma opa menipis. Bantuan kecil darimu sangat berarti 💙', 'color': Color(0xFFDCEAFB)},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopHeader(showBack: true, onNotification: _showFilterMenu),
      bottomNavigationBar: AppBottomNav(currentIndex: _selectedIndex, onTap: _onNavTap),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: notifications
            .map((section) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(section['date'], style: AppTextStyles.heading.copyWith(fontSize: 16)),
                  const SizedBox(height: 8),
                  ...section['items'].map<Widget>((item) => Card(
                        color: item['color'],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(item['msg'], style: AppTextStyles.body),
                        ),
                      )),
                  const SizedBox(height: 12),
                ]))
            .toList(),
      ),
    );
  }
}