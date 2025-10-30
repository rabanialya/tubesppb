import 'package:flutter/material.dart';
import '../../../widgets/top_header.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_input.dart';
import '../../../themes/colors.dart';
import '../../../themes/text_styles.dart';

class DonationGoodsPage extends StatefulWidget {
  const DonationGoodsPage({super.key});

  @override
  State<DonationGoodsPage> createState() => _DonationGoodsPageState();
}

class _DonationGoodsPageState extends State<DonationGoodsPage> {
  final _nama = TextEditingController();
  final _hp = TextEditingController();
  final _barang = TextEditingController();
  final _jumlah = TextEditingController();
  final _tanggal = TextEditingController();
  final _catatan = TextEditingController();

  int _selectedIndex = 1;

  final List<Map<String, String>> _needs = [
    {'item': 'Pampers size L', 'jumlah': '5 bungkus'},
    {'item': 'Minyak telon', 'jumlah': '10 botol'},
    {'item': 'Sabun mandi', 'jumlah': '6 bungkus'},
    {'item': 'Tisu kering', 'jumlah': '10 buah'},
    {'item': 'Sikat gigi', 'jumlah': '8 buah'},
    {'item': 'Detergen', 'jumlah': '10 bungkus'},
  ];

  void _submitDonation() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text('Terima Kasih!'),
        content: const Text(
          'Terima kasih atas donasi Anda! Silakan kirim barang ke panti '
          'atau hubungi admin untuk penjemputan.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _onNavTap(int index) {
    if (index == 0) Navigator.pushReplacementNamed(context, '/home');
    if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopHeader(showBack: true, onNotification: () => Navigator.pushNamed(context, '/notification')),
      bottomNavigationBar: AppBottomNav(currentIndex: _selectedIndex, onTap: _onNavTap),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Kebutuhan Saat Ini', style: AppTextStyles.heading),
          const SizedBox(height: 8),
          ..._needs.map((n) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.inventory_2, color: AppColors.primaryBlue),
                  title: Text(n['item']!),
                  subtitle: Text('Kebutuhan: ${n['jumlah']}'),
                ),
              )),
          const SizedBox(height: 20),
          const Divider(thickness: 1),
          const SizedBox(height: 8),
          const Text('Formulir Donasi Barang', style: AppTextStyles.heading),
          const SizedBox(height: 12),
          CustomInput(controller: _nama, label: 'Nama Donatur'),
          const SizedBox(height: 12),
          CustomInput(controller: _hp, label: 'Nomor HP / WhatsApp', keyboardType: TextInputType.phone),
          const SizedBox(height: 12),
          CustomInput(controller: _barang, label: 'Jenis Barang'),
          const SizedBox(height: 12),
          CustomInput(controller: _jumlah, label: 'Jumlah Barang', keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          CustomInput(controller: _tanggal, label: 'Tanggal Pengiriman'),
          const SizedBox(height: 12),
          CustomInput(controller: _catatan, label: 'Catatan Tambahan', maxLines: 3),
          const SizedBox(height: 20),
          Center(child: CustomButton(text: 'Kirim Donasi', onPressed: _submitDonation)),
        ]),
      ),
    );
  }
}