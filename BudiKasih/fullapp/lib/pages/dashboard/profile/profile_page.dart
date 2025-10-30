import 'package:flutter/material.dart';
import '../../../widgets/top_header.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../../themes/colors.dart';
import '../../../themes/text_styles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2;

  void _onNavTap(int index) {
    if (index == 0) Navigator.pushReplacementNamed(context, '/home');
    if (index == 1) Navigator.pushReplacementNamed(context, '/donationgoods');
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text('Konfirmasi Logout', style: AppTextStyles.heading),
        content: const Text('Apakah Anda yakin ingin keluar?', style: AppTextStyles.body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Anda telah logout')));
              },
              child: const Text('Logout', style: TextStyle(color: AppColors.primaryBlue))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopHeader(showBack: true, onNotification: () => Navigator.pushNamed(context, '/notification')),
      bottomNavigationBar: AppBottomNav(currentIndex: _selectedIndex, onTap: _onNavTap),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                const CircleAvatar(radius: 45, backgroundColor: AppColors.primaryBlue, child: Icon(Icons.person, color: Colors.white, size: 50)),
                const SizedBox(height: 12),
                const Text('Isabell Conklin', style: AppTextStyles.heading),
                const SizedBox(height: 16),
                ListTile(leading: const Icon(Icons.settings), title: const Text('Pengaturan Akun'), onTap: () {}),
                ListTile(leading: const Icon(Icons.history), title: const Text('Riwayat Aktivitas'), onTap: () {}),
                ListTile(leading: const Icon(Icons.help_outline), title: const Text('Bantuan'), onTap: () {}),
                ListTile(leading: const Icon(Icons.info_outline), title: const Text('Tentang'), onTap: () {}),
                ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout', style: TextStyle(color: Colors.red)),
                    onTap: _showLogoutDialog),
              ],
            ),
          ),
        ),
      ),
    );
  }
}