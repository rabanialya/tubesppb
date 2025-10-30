import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotificationPage> {
  String selectedFilter = 'Semua';

  // Bottom sheet filter
  void _showFilterMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFE6EEF8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption(context, 'Semua'),
              _buildFilterOption(context, 'Belum Dibaca'),
              _buildFilterOption(context, 'Sudah Dibaca'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(BuildContext context, String text) {
    return ListTile(
      title: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: selectedFilter == text ? FontWeight.bold : FontWeight.normal,
            color: selectedFilter == text ? const Color(0xFF2A67B1) : const Color(0xFF122B4B),
          ),
        ),
      ),
      onTap: () {
        setState(() => selectedFilter = text);
        Navigator.pop(context);
      },
    );
  }

  // Dialog laporan donasi
  void _showLaporanDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFE6EEF8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Laporan Donasi',
          style: TextStyle(
            color: Color(0xFF122B4B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Bantuanmu telah kami terima dan akan segera kami distribusikan '
          'kepada lansia yang membutuhkan.\n\n'
          'Berikut merupakan lampiran bukti penerimaan:\n'
          '📎 Bukti_Penerimaan_Barang_MinyakKayuPutih_2025-10-22.pdf\n\n'
          'Doa dan bantuanmu sangat berarti bagi mereka. '
          'Semoga kebaikanmu dibalas dengan berlipat ganda. 💙',
          style: TextStyle(
            color: Color(0xFF122B4B),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Color(0xFF2A67B1)),
            ),
          ),
        ],
      ),
    );
  }

  // Widget kartu notifikasi
  Widget _buildNotificationCard({
    required String message,
    Color? color,
    bool hasLink = false,
  }) {
    final isClickable = hasLink && message.contains('klik');
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Color(0xFF122B4B), fontSize: 14, height: 1.5),
          children: [
            TextSpan(text: '$message '),
            if (isClickable)
              WidgetSpan(
                child: GestureDetector(
                  onTap: _showLaporanDialog,
                  child: const Text(
                    'Klik untuk melihat laporan',
                    style: TextStyle(
                      color: Color(0xFF2A67B1),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'date': 'Hari ini, 23/10/25',
        'items': [
          {
            'msg':
                'Donasi barang berupa minyak kayu putih 1 lusin telah diterima pihak panti.',
            'color': const Color(0xFFDCEAFB),
            'link': true,
          },
          {
            'msg':
                'Donasi anda sedang diproses, pihak panti akan mengirimkan prosedur pengiriman.',
            'color': const Color(0xFFEAF8EA),
            'link': false,
          },
        ]
      },
      {
        'date': 'Kemarin, 22/10/25',
        'items': [
          {
            'msg':
                'Halo sobat BudiKasih! Ketersediaan underpad untuk oma opa menipis. '
                'Bantuan kecil darimu sangat berarti 💙',
            'color': const Color(0xFFDCEAFB),
            'link': false,
          },
        ]
      },
      {
        'date': '9/08/25',
        'items': [
          {
            'msg':
                'Peringatan: donasi tunai anda belum dapat kami proses. Silahkan coba kembali beberapa saat lagi.',
            'color': const Color(0xFFFFEAEA),
            'link': false,
          },
        ]
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE6EEF8),

      appBar: AppBar(
        title: const Text('Notifikasi', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2A67B1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterMenu(context),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF122B4B),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 1,
        onTap: (index) {
          // TODO: tambahkan navigasi antar halaman
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.volunteer_activism), label: 'Donasi Sekarang'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isCompact = width < 400;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 16 : 24,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: notifications.map((section) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section['date'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isCompact ? 14 : 16,
                        color: const Color(0xFF122B4B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...(section['items'] as List).map((item) {
                      return _buildNotificationCard(
                        message: item['msg'],
                        color: item['color'],
                        hasLink: item['link'],
                      );
                    }).toList(),
                    const SizedBox(height: 14),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}