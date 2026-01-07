import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../themes/colors.dart';
import '../../../themes/text_styles.dart';
import '../../../themes/app_theme.dart';
import '../../../widgets/reusable/top_header.dart';
import '../../../widgets/reusable/app_bottom_nav.dart';
import '../../../widgets/reusable/bg_container.dart';
import '../../../widgets/donation/donation_need_card.dart';
import '../../../widgets/donation/donation_modal.dart';
import '../../../widgets/donation/goods_donation_form.dart';
import '../../../controllers/donasi_controller.dart';

class DonationGoodsPage extends StatefulWidget {
  const DonationGoodsPage({super.key});

  @override
  State<DonationGoodsPage> createState() => _DonationGoodsPageState();
}

class _DonationGoodsPageState extends State<DonationGoodsPage> {
  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _hp = TextEditingController();
  final _barang = TextEditingController();
  final _jumlah = TextEditingController();
  final _catatan = TextEditingController();

  int _selectedIndex = 1;
  bool _showForm = false;

  final List<Map<String, dynamic>> _needs = [
    {
      'item': 'Pampers Dewasa',
      'size': 'Size L',
      'jumlah': '5 bungkus',
      'priority': 'high',
      'icon': Icons.healing,
      'current': 2,
      'target': 5,
    },
    {
      'item': 'Minyak Telon',
      'size': 'Ukuran besar',
      'jumlah': '10 botol',
      'priority': 'high',
      'icon': Icons.local_hospital,
      'current': 4,
      'target': 10,
    },
    {
      'item': 'Sabun Mandi',
      'size': 'Batangan',
      'jumlah': '6 bungkus',
      'priority': 'medium',
      'icon': Icons.soap,
      'current': 3,
      'target': 6,
    },
    {
      'item': 'Tisu Kering',
      'size': 'Box besar',
      'jumlah': '10 box',
      'priority': 'medium',
      'icon': Icons.inventory_2,
      'current': 6,
      'target': 10,
    },
    {
      'item': 'Sikat Gigi',
      'size': 'Bulu halus',
      'jumlah': '8 buah',
      'priority': 'low',
      'icon': Icons.cleaning_services,
      'current': 5,
      'target': 8,
    },
    {
      'item': 'Detergen',
      'size': 'Kemasan 1kg',
      'jumlah': '10 bungkus',
      'priority': 'low',
      'icon': Icons.local_laundry_service,
      'current': 7,
      'target': 10,
    },
  ];

  Future<void> _submitDonation() async {
    // Validation
    if (_nama.text.trim().isEmpty) {
      _showSnackBar('Nama donatur harus diisi', Colors.orange);
      return;
    }
    if (_email.text.trim().isEmpty) {
      _showSnackBar('Email donatur harus diisi', Colors.orange);
      return;
    }
    if (_hp.text.trim().isEmpty) {
      _showSnackBar('Nomor HP harus diisi', Colors.orange);
      return;
    }
    if (_barang.text.trim().isEmpty) {
      _showSnackBar('Jenis barang harus diisi', Colors.orange);
      return;
    }
    if (_jumlah.text.trim().isEmpty) {
      _showSnackBar('Jumlah barang harus diisi', Colors.orange);
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final controller = Provider.of<DonasiController>(context, listen: false);
      
      final success = await controller.createDonationBarang(
        donatur: _nama.text.trim(),
        email: _email.text.trim(),
        hp: _hp.text.trim(),
        barang: _barang.text.trim(),
        jumlah: _jumlah.text.trim(),
        catatan: _catatan.text.trim().isEmpty ? null : _catatan.text.trim(),
      );

      // Close loading
      if (mounted) Navigator.pop(context);

      if (success) {
        _showSuccessDialog();
      } else {
        _showSnackBar(
          controller.errorMessage ?? 'Gagal mengirim donasi',
          Colors.red,
        );
      }
    } catch (e) {
      // Close loading
      if (mounted) Navigator.pop(context);
      _showSnackBar('Error: $e', Colors.red);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Terima Kasih!',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Donasi Anda sangat berarti bagi Oma & Opa di panti.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Selanjutnya:',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '• Kirim barang ke alamat panti\n• Atau hubungi admin untuk penjemputan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kembali ke Beranda',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      showDonationModal(context);
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  Widget _buildNeedsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBlue,
                AppColors.primaryBlue.withOpacity(0.8)
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kebutuhan Saat Ini',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pilih dan bantu kebutuhan yang paling mendesak untuk panti',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ..._needs.map((n) {
          return DonationNeedCard(
            item: n['item'],
            size: n['size'],
            jumlah: n['jumlah'],
            priority: n['priority'],
            icon: n['icon'],
            current: n['current'],
            target: n['target'],
          );
        }).toList(),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _showForm = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Donasi Sekarang',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      children: [
        GoodsDonationForm(
          namaController: _nama,
          emailController: _email,
          hpController: _hp,
          barangController: _barang,
          jumlahController: _jumlah,
          catatanController: _catatan,
          onSubmit: _submitDonation,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _showForm = false),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Batal'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopHeader(
        showBack: true,
        onNotification: () => Navigator.pushNamed(context, '/notification'),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
      body: BackgroundContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _showForm ? _buildFormSection() : _buildNeedsSection(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _hp.dispose();
    _barang.dispose();
    _jumlah.dispose();
    _catatan.dispose();
    super.dispose();
  }
}