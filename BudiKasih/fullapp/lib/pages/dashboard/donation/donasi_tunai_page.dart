import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../widgets/top_header.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_input.dart';
import '../../../themes/colors.dart';
import '../../../themes/text_styles.dart';

class DonationCashPage extends StatefulWidget {
  const DonationCashPage({super.key});

  @override
  State<DonationCashPage> createState() => _DonationCashPageState();
}

class _DonationCashPageState extends State<DonationCashPage> {
  final _nama = TextEditingController();
  final _hp = TextEditingController();
  final _catatan = TextEditingController();

  File? _buktiTransfer;
  final picker = ImagePicker();
  int _selectedIndex = 1;

  Future<void> _pickImage() async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _buktiTransfer = File(file.path));
    }
  }

  void _submit() {
    if (_buktiTransfer == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Mohon upload bukti transfer')));
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text('Terima Kasih!'),
        content: const Text(
          'Donasi tunai Anda telah diterima! Tim kami akan mengonfirmasi melalui WhatsApp.',
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))],
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
          const Text('Formulir Donasi Tunai', style: AppTextStyles.heading),
          const SizedBox(height: 16),
          CustomInput(controller: _nama, label: 'Nama Lengkap'),
          const SizedBox(height: 12),
          CustomInput(controller: _hp, label: 'Nomor HP / WhatsApp', keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Transfer ke rekening:\n\nBCA: 1234567890\nA.n. Yayasan Panti Wredha Budi Dharma Kasih',
                style: AppTextStyles.body),
          ),
          const SizedBox(height: 16),
          const Text('Upload Bukti Transfer', style: AppTextStyles.heading),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: _buktiTransfer != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_buktiTransfer!, fit: BoxFit.cover),
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined, color: Colors.grey, size: 40),
                          SizedBox(height: 8),
                          Text('Tap untuk memilih foto', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          CustomInput(controller: _catatan, label: 'Catatan (opsional)', maxLines: 3),
          const SizedBox(height: 20),
          Center(child: CustomButton(text: 'Kirim Donasi', onPressed: _submit)),
        ]),
      ),
    );
  }
}