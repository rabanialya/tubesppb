import 'package:flutter/material.dart';

import '../../../themes/colors.dart';
import '../../../themes/text_styles.dart';
import '../../../themes/app_theme.dart';

import '../../../widgets/reusable/top_header.dart';
import '../../../widgets/reusable/app_bottom_nav.dart';
import '../../../widgets/reusable/bg_container.dart';
import '../../../widgets/donation/donation_modal.dart';
import '../../../widgets/profile/profile_header.dart';
import '../../../widgets/profile/profile_menu_card.dart';
import '../../../widgets/profile/edit_profile_sheet.dart';
import '../../../widgets/profile/info_dialog.dart';
import '../../../widgets/profile/logout_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int currentIndex = 2;

  // Data user sementara
  String name = 'Isabell Conklin';
  String email = 'isabell@example.com';
  String? profileImagePath;

  final nameC = TextEditingController(text: 'Isabell Conklin');
  final emailC = TextEditingController(text: 'isabell@example.com');
  final passC = TextEditingController();

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      showDonationModal(context);
    }
  }

  void _openEditProfile() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => EditProfileSheet(
        nameC: nameC,
        emailC: emailC,
        passwordC: passC,
      ),
    );

    if (result == true) {
      setState(() {
        name = nameC.text;
        email = emailC.text;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profil berhasil diperbarui!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopHeader(
        showBack: true,
        onNotification: () => Navigator.pushNamed(context, '/notification'),
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        onTap: _onNavTap,
      ),

      body: BackgroundContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ProfileHeader(
                name: name,
                email: email,
                onImageSelected: (path) {
                  setState(() => profileImagePath = path);
                },
              ),

              const SizedBox(height: 24),

              // MENU CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ProfileMenuCard(
                      icon: Icons.edit,
                      title: 'Edit Profil',
                      onTap: _openEditProfile,
                    ),
                    ProfileMenuCard(
                      icon: Icons.history,
                      title: 'Riwayat Donasi',
                      onTap: () {
                        InfoDialog.show(
                          context,
                          'Riwayat Donasi',
                          '• Donasi Barang: Pampers Size L (20/10/25)\n'
                              '• Donasi Tunai: Rp100.000 (22/10/25)\n'
                              '• Pesan Cinta ke Oma Rini (23/10/25)',
                        );
                      },
                    ),
                    ProfileMenuCard(
                      icon: Icons.help_outline,
                      title: 'Bantuan',
                      onTap: () {
                        InfoDialog.show(
                          context,
                          'Bantuan',
                          'Hubungi admin:\n📞 +62 813-9466-1664\n✉️ admin@budikasih.org',
                        );
                      },
                    ),
                    ProfileMenuCard(
                      icon: Icons.info_outline,
                      title: 'Tentang Aplikasi',
                      onTap: () {
                        InfoDialog.show(
                          context,
                          'Tentang Aplikasi',
                          'BudiKasih adalah aplikasi resmi milik Panti Wredha Budi Dharma Kasih Purbalingga yang dirancang untuk mempermudah masyarakat dalam berbagi kasih, melakukan donasi, dan mengenal lebih dekat kehidupan para lansia di panti. Aplikasi ini hadir sebagai jembatan digital yang mempertemukan para donatur dengan kebutuhan panti secara cepat, aman, dan praktis. \n ',
                        );
                      },
                    ),
                    ProfileMenuCard(
                      icon: Icons.logout,
                      title: 'Keluar',
                      onTap: () => LogoutDialog.show(context),
                      iconColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}