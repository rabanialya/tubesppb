import 'package:flutter/material.dart';
import '../../themes/text_styles.dart';
import '../../themes/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passController = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryBlue, AppColors.darkBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Masuk ke Akun Anda',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 28),

            CustomInput(
              controller: emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            CustomInput(
              controller: passController,
              label: 'Password',
              obscure: true,
            ),
            const SizedBox(height: 24),

            // 👉 langsung ke halaman beranda
            CustomButton(
              text: 'Masuk',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              background: Colors.white,
              textColor: AppColors.darkBlue,
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text(
                'Belum punya akun? Daftar',
                style: TextStyle(color: Colors.white),
              ),
            ),

            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/setting_pass'),
              child: const Text(
                'Lupa Password?',
                style: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 8),

            TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
              child: const Text(
                'Kembali ke Welcome',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}