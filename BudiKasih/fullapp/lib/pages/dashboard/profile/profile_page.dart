import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget _buildMenuItem(
      IconData icon, String title, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFE6EEF8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Konfirmasi Logout',
          style: TextStyle(
            color: Color(0xFF122B4B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar?',
          style: TextStyle(color: Color(0xFF122B4B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Anda telah logout')),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFF2A67B1)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color mainBlue = Color(0xFF2A67B1);
    const Color darkBlue = Color(0xFF122B4B);

    return Scaffold(
      backgroundColor: const Color(0xFFE6EEF8),

      appBar: AppBar(
        backgroundColor: mainBlue,
        title: const Text('Profil', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: darkBlue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 2,
        onTap: (index) {
          // TODO: hubungkan ke halaman lain nanti
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
              horizontal: isCompact ? 16 : 32,
              vertical: 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Container(
                  padding: EdgeInsets.all(isCompact ? 12 : 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar & nama pengguna
                      CircleAvatar(
                        radius: isCompact ? 35 : 45,
                        backgroundColor: mainBlue.withOpacity(0.2),
                        child: const Icon(
                          Icons.person,
                          size: 55,
                          color: darkBlue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Isabell Conklin',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Menu
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: mainBlue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildMenuItem(
                                Icons.settings, 'Pengaturan Akun', () {}, darkBlue),
                            const Divider(height: 1, color: Colors.grey),
                            _buildMenuItem(Icons.history, 'Riwayat Aktivitas',
                                () {}, darkBlue),
                            const Divider(height: 1, color: Colors.grey),
                            _buildMenuItem(
                                Icons.help_outline, 'Bantuan', () {}, darkBlue),
                            const Divider(height: 1, color: Colors.grey),
                            _buildMenuItem(
                                Icons.info_outline, 'Tentang', () {}, darkBlue),
                            const Divider(height: 1, color: Colors.grey),
                            _buildMenuItem(Icons.logout, 'Logout',
                                () => _showLogoutDialog(context), darkBlue),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}