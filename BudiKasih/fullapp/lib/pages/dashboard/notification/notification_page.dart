import 'package:flutter/material.dart';
import '../../../widgets/top_header.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../../widgets/bg_container.dart';
import '../../../widgets/donation_modal.dart';
import '../../../themes/colors.dart';
import '../../../themes/text_styles.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String selectedFilter = 'Semua';
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      showDonationModal(context); // ✅ Gunakan fungsi dari donation_modal.dart
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Filter Notifikasi',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
              const SizedBox(height: 20),
              _filterOption('Semua', Icons.notifications),
              _filterOption('Belum Dibaca', Icons.mark_email_unread),
              _filterOption('Sudah Dibaca', Icons.mark_email_read),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterOption(String text, IconData icon) {
    final isSelected = selectedFilter == text;
    return InkWell(
      onTap: () {
        setState(() => selectedFilter = text);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBlue : Colors.grey[600],
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: isSelected ? AppColors.primaryBlue : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryBlue,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  // Method untuk menampilkan detail notifikasi
  void _showNotificationDetail(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      notification['iconColor'] as Color,
                      (notification['iconColor'] as Color).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        notification['icon'],
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Detail Laporan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pesan Notifikasi
                      Text(
                        notification['msg'],
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkBlue,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Detail berdasarkan tipe
                      if (notification['type'] == 'donation_received') ...[
                        _buildDetailSection('Informasi Donasi', [
                          _buildDetailRow(Icons.person, 'Nama Donatur', notification['detail']?['donorName'] ?? 'Anonymous'),
                          _buildDetailRow(Icons.inventory_2, 'Jenis', notification['detail']?['type'] ?? 'Donasi Barang'),
                          _buildDetailRow(Icons.check_circle_outline, 'Status', 'Diterima'),
                          _buildDetailRow(Icons.calendar_today, 'Tanggal', notification['detail']?['date'] ?? '08/11/2025'),
                        ]),
                        const SizedBox(height: 16),
                        _buildDetailSection('Detail Barang', [
                          _buildDetailRow(Icons.shopping_bag, 'Item', notification['detail']?['item'] ?? 'Pampers Dewasa Size L'),
                          _buildDetailRow(Icons.numbers, 'Jumlah', notification['detail']?['quantity'] ?? '5 bungkus'),
                        ]),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.favorite, color: Colors.green.shade700, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Terima kasih atas kebaikan Anda! Donasi ini sangat membantu kesejahteraan para lansia.',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: Colors.green.shade700,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (notification['type'] == 'cash_verified') ...[
                        _buildDetailSection('Informasi Donasi Tunai', [
                          _buildDetailRow(Icons.account_balance_wallet, 'Nominal', notification['detail']?['amount'] ?? 'Rp 500.000'),
                          _buildDetailRow(Icons.payment, 'Metode', notification['detail']?['method'] ?? 'Transfer Bank BCA'),
                          _buildDetailRow(Icons.check_circle, 'Status', 'Terverifikasi'),
                          _buildDetailRow(Icons.calendar_today, 'Tanggal', notification['detail']?['date'] ?? '07/11/2025'),
                        ]),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.verified, color: Colors.blue.shade700, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Donasi tunai Anda telah dikonfirmasi dan akan digunakan untuk kebutuhan panti.',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: Colors.blue.shade700,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (notification['type'] == 'message_received') ...[
                        _buildDetailSection('Pesan Terkirim', [
                          _buildDetailRow(Icons.mail, 'Penerima', notification['detail']?['recipient'] ?? 'Oma Rini'),
                          _buildDetailRow(Icons.calendar_today, 'Tanggal', notification['detail']?['date'] ?? '07/11/2025'),
                        ]),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            notification['detail']?['message'] ?? 'Semangat Oma Rini! Semoga selalu sehat dan bahagia 💕',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.black87,
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ] else if (notification['type'] == 'urgent_need') ...[
                        _buildDetailSection('Kebutuhan Mendesak', [
                          _buildDetailRow(Icons.priority_high, 'Prioritas', 'Tinggi'),
                          _buildDetailRow(Icons.inventory_2, 'Item', notification['detail']?['item'] ?? 'Susu Lansia & Vitamin'),
                          _buildDetailRow(Icons.numbers, 'Dibutuhkan', notification['detail']?['needed'] ?? '10 box'),
                        ]),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/donationgoods');
                            },
                            icon: const Icon(Icons.volunteer_activism),
                            label: const Text('Bantu Sekarang'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 20),
                      // Footer info
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Untuk informasi lebih lanjut, hubungi admin melalui WhatsApp',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryBlue),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Text(
                  '$label: ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
          'msg': 'Donasi barang berupa Pampers telah sampai di panti. Terima kasih atas kebaikan Anda! 💝',
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
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showFilterMenu,
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
      body: BackgroundContainer(
        child: SafeArea(
          child: notifications.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  itemBuilder: (context, sectionIndex) {
                    final section = notifications[sectionIndex];
                    final filteredItems = (section['items'] as List).where((item) {
                      if (selectedFilter == 'Belum Dibaca') {
                        return !(item['isRead'] as bool);
                      } else if (selectedFilter == 'Sudah Dibaca') {
                        return item['isRead'] as bool;
                      }
                      return true;
                    }).toList();

                    if (filteredItems.isEmpty) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 12),
                          child: Text(
                            section['date'],
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBlue,
                            ),
                          ),
                        ),
                        ...filteredItems.map<Widget>((item) {
                          return _buildNotificationCard(item);
                        }).toList(),
                        if (sectionIndex < notifications.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> item) {
    final isRead = item['isRead'] as bool;
    final bgColor = isRead ? Colors.white : Colors.blue.shade50;
    
    return InkWell(
      onTap: () {
        // Mark as read when opened
        setState(() {
          item['isRead'] = true;
        });
        _showNotificationDetail(item);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: bgColor.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead ? Colors.grey[200]! : AppColors.primaryBlue.withOpacity(0.3),
            width: isRead ? 1 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (item['iconColor'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item['icon'],
                  color: item['iconColor'],
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['msg'],
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                        fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),
                    if (!isRead) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'BARU',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ketuk untuk detail',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Notifikasi',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Notifikasi akan muncul di sini',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}