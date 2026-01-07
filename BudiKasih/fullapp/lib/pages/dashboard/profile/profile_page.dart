import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../themes/colors.dart';
import '../../../themes/text_styles.dart';
import '../../../widgets/reusable/top_header.dart';
import '../../../widgets/reusable/app_bottom_nav.dart';
import '../../../widgets/reusable/bg_container.dart';
import '../../../widgets/donation/donation_modal.dart';
import '../../../core/storage/token_storage.dart';
import '../../../core/config/api_config.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int currentIndex = 2;

  // Data user
  String name = '';
  String email = '';
  String? profileImagePath;

  // Text controllers - HANYA UNTUK NAMA SAJA
  final TextEditingController nameController = TextEditingController();

  bool isEditing = false;
  bool isSaving = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  // LOAD USER DATA DARI STORAGE
  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    final user = await TokenStorage.getUser();
    
    if (user != null) {
      setState(() {
        name = user['nama'] ?? '';
        email = user['email'] ?? '';
        nameController.text = name;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      showDonationModal(context);
    }
  }

  void _startEditing() {
    setState(() {
      isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      isEditing = false;
      nameController.text = name; // Reset ke nama asli
    });
  }

  // SIMPAN PROFILE - HANYA UPDATE NAMA
  Future<void> _saveProfile() async {
    if (nameController.text.isEmpty) {
      _showSnackBar('Nama tidak boleh kosong', Colors.red);
      return;
    }

    // Jika nama sama, tidak perlu update
    if (nameController.text == name) {
      setState(() {
        isEditing = false;
      });
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      // Hanya kirim nama (email tidak bisa diubah)
      final updateData = {
        'nama': nameController.text,
      };

      // Kirim ke API Laravel
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          // Update data di storage
          final user = await TokenStorage.getUser();
          if (user != null) {
            await TokenStorage.saveUser(
              user['id'],
              nameController.text,
              user['email'], // Email tetap sama
            );
          }

          setState(() {
            name = nameController.text;
            isEditing = false;
            isSaving = false;
          });

          _showSnackBar('Nama berhasil diperbarui!', Colors.green);
        } else {
          throw Exception(data['message'] ?? 'Gagal update profil');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Error ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isSaving = false;
      });
      _showSnackBar('Gagal update: ${e.toString().replaceAll("Exception: ", "")}', Colors.red);
    }
  }

  // LOGOUT - TANPA PAKAI AUTH SERVICE
  Future<void> _logout() async {
    try {
      final token = await TokenStorage.getToken();
      if (token != null) {
        // Kirim request logout ke API jika ada token
        await http.post(
          Uri.parse('${ApiConfig.baseUrl}/logout'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (e) {
      // Ignore error, tetap logout
    } finally {
      // Selalu clear storage
      await TokenStorage.clearAll();
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/login', 
        (route) => false
      );
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        )),
        content: Text(message, style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Akun'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: 40,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isNotEmpty ? name : 'Loading...',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email.isNotEmpty ? email : 'loading...',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                if (!isEditing && !isLoading)
                  ElevatedButton(
                    onPressed: _startEditing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(100, 36),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, size: 16),
                        SizedBox(width: 8),
                        Text('Edit Profil'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Edit Profile
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit Profil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: _cancelEditing,
                icon: const Icon(Icons.close),
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // HANYA NAMA SAJA YANG BISA DIEDIT
          _buildFormField(
            label: 'Nama Lengkap',
            hintText: 'Masukkan nama lengkap',
            controller: nameController,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),

          // EMAIL HANYA READ-ONLY (TIDAK BISA DIEDIT)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  children: [
                    Icon(Icons.email_outlined, color: Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        email,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Tooltip(
                      message: 'Email tidak dapat diubah',
                      child: Icon(Icons.info_outline, color: Colors.grey, size: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Email tidak dapat diubah',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSaving ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: AppColors.primaryBlue.withOpacity(0.5),
              ),
              child: isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Simpan Perubahan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              prefixIcon: Icon(icon, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.primaryBlue,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: TopHeader(
          showBack: true,
          onNotification: () => Navigator.pushNamed(context, '/notification'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
              _buildProfileHeader(),

              // Jika sedang edit, tampilkan form edit
              if (isEditing) ...[
                _buildEditProfileForm(),
                const SizedBox(height: 20),
              ],

              // Menu Cards
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuCard(
                      icon: Icons.history,
                      title: 'Riwayat Donasi',
                      onTap: () {
                        Navigator.pushNamed(context, '/history');
                      },
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    _buildMenuCard(
                      icon: Icons.help_outline,
                      title: 'Bantuan',
                      onTap: () {
                        _showInfoDialog(
                          'Bantuan',
                          'Hubungi admin:\n📞 +62 813-9466-1664\n✉️ admin@budikasih.org',
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    _buildMenuCard(
                      icon: Icons.info_outline,
                      title: 'Tentang Aplikasi',
                      onTap: () {
                        _showInfoDialog(
                          'Tentang Aplikasi',
                          'BudiKasih adalah aplikasi resmi milik Panti Wredha Budi Dharma Kasih Purbalingga yang dirancang untuk mempermudah masyarakat dalam berbagi kasih, melakukan donasi, dan mengenal lebih dekat kehidupan para lansia di panti. Aplikasi ini hadir sebagai jembatan digital yang mempertemukan para donatur dengan kebutuhan panti secara cepat, aman, dan praktis.',
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    _buildMenuCard(
                      icon: Icons.logout,
                      title: 'Keluar',
                      onTap: _showLogoutDialog,
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