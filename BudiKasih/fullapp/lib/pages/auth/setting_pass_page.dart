import 'package:flutter/material.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/top_header.dart';

class SettingPassPage extends StatefulWidget {
  const SettingPassPage({super.key});

  @override
  State<SettingPassPage> createState() => _SettingPassPageState();
}

class _SettingPassPageState extends State<SettingPassPage> {
  final _old = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();

  void _changePassword() {
    // buat sementara: validasi sederhana
    if (_new.text.isEmpty || _confirm.text.isEmpty || _new.text != _confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Periksa input password')));
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Berhasil'),
        content: const Text('Password berhasil diperbarui. Silakan login kembali jika perlu.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopHeader(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            CustomInput(controller: _old, label: 'Password Lama', obscure: true),
            const SizedBox(height: 12),
            CustomInput(controller: _new, label: 'Password Baru', obscure: true),
            const SizedBox(height: 12),
            CustomInput(controller: _confirm, label: 'Konfirmasi Password', obscure: true),
            const SizedBox(height: 20),
            CustomButton(text: 'Simpan', onPressed: _changePassword),
          ],
        ),
      ),
    );
  }
}