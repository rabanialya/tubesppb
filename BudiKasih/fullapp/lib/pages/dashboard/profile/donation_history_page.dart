import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/reusable/app_bottom_nav.dart';
import '../../../widgets/reusable/bg_container.dart';
import '../../../widgets/donation/donation_modal.dart';

import '../../../themes/colors.dart';

class DonationHistoryPage extends StatefulWidget {
  const DonationHistoryPage({super.key});

  @override
  State<DonationHistoryPage> createState() => _DonationHistoryPageState();
}

class _DonationHistoryPageState extends State<DonationHistoryPage> {
  int _selectedIndex = 2;

  // ===================== DATA =====================
  final List<Map<String, dynamic>> donationHistory = [
    {
      'date': 'Hari ini, 23/10/25',
      'items': [
        {
          'type': 'Tunai',
          'description': 'Melakukan donasi tunai dengan nominal 1.000.000',
          'amount': 'Rp 1.000.000',
          'icon': Icons.account_balance_wallet,
          'color': Colors.green,
        },
      ],
    },
    {
      'date': '9/08/25',
      'items': [
        {
          'type': 'Barang',
          'description': 'Melakukan donasi barang berupa pampers sebanyak 1 dos',
          'amount': '1 dos Pampers',
          'icon': Icons.inventory_2,
          'color': AppColors.primaryBlue,
        },
      ],
    },
    {
      'date': '15/07/25',
      'items': [
        {
          'type': 'Tunai',
          'description': 'Melakukan donasi tunai dengan nominal 500.000',
          'amount': 'Rp 500.000',
          'icon': Icons.account_balance_wallet,
          'color': Colors.green,
        },
      ],
    },
    {
      'date': '02/06/25',
      'items': [
        {
          'type': 'Barang',
          'description': 'Melakukan donasi barang berupa sabun mandi sebanyak 5 bungkus',
          'amount': '5 bungkus Sabun',
          'icon': Icons.inventory_2,
          'color': AppColors.primaryBlue,
        },
        {
          'type': 'Tunai',
          'description': 'Melakukan donasi tunai dengan nominal 250.000',
          'amount': 'Rp 250.000',
          'icon': Icons.account_balance_wallet,
          'color': Colors.green,
        },
      ],
    },
  ];

  // ===================== NAV =====================
  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      showDonationModal(context);
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

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
        title: Text(
          'Riwayat Donasi',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
      body: BackgroundContainer(
        child: donationHistory.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: donationHistory.length,
                itemBuilder: (context, index) {
                  return _buildSection(donationHistory[index]);
                },
              ),
      ),
    );
  }

  // ===================== EMPTY =====================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada riwayat donasi',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Mulai berbagi kebaikan untuk Oma & Opa',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== SECTION =====================
  Widget _buildSection(Map<String, dynamic> section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            section['date'],
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
        ),
        ...section['items']
            .map<Widget>((item) => _buildDonationCard(item))
            .toList(),
        const SizedBox(height: 20),
      ],
    );
  }

  // ===================== CARD =====================
  Widget _buildDonationCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item['color'].withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item['icon'], color: item['color'], size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _typeBadge(item),
                    const Spacer(),
                    Text(
                      item['amount'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: item['color'],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item['description'],
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeBadge(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: item['color'].withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        item['type'],
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: item['color'],
        ),
      ),
    );
  }
}