import 'package:flutter/material.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/custom_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  void _register() {
    if (_pass.text != _confirm.text || _pass.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Periksa password & konfirmasi')));
      return;
    }
    // mock: kembali ke login
    Navigator.popAndPushNamed(context, '/login');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Akun berhasil dibuat (mock)')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF2A67B1), Color(0xFF122B4B)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Buat Akun Baru', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 28),
            CustomInput(controller: _name, label: 'Nama Lengkap'),
            const SizedBox(height: 12),
            CustomInput(controller: _email, label: 'Email'),
            const SizedBox(height: 12),
            CustomInput(controller: _pass, label: 'Password', obscure: true),
            const SizedBox(height: 12),
            CustomInput(controller: _confirm, label: 'Konfirmasi Password', obscure: true),
            const SizedBox(height: 18),
            CustomButton(text: 'Daftar', onPressed: _register, background: Colors.white, textColor: Color(0xFF122B4B)),
            const SizedBox(height: 12),
            TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/login'), child: const Text('Sudah punya akun? Masuk', style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
