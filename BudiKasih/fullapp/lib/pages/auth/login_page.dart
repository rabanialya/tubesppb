import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../themes/colors.dart';
import '../../themes/text_styles.dart';
import '../../../themes/app_theme.dart';

import '../../widgets/auth/custom_text_field.dart';
import '../../widgets/auth/logo_circle.dart';
import '../../widgets/auth/input_label.dart';

import '../../controllers/auth_controller.dart';
import '../dashboard/homepage.dart'; // ✅ TAMBAH IMPORT INI

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // FUNGSI LOGIN - UPDATE INI
  Future<void> _handleLogin() async {
    // Validasi sederhana
    if (emailController.text.trim().isEmpty) {
      _showError('Email tidak boleh kosong');
      return;
    }
    if (!emailController.text.contains('@')) {
      _showError('Format email tidak valid');
      return;
    }
    if (passwordController.text.isEmpty) {
      _showError('Password tidak boleh kosong');
      return;
    }

    // Hilangkan keyboard
    FocusScope.of(context).unfocus();

    final authController = Provider.of<AuthController>(context, listen: false);

    final success = await authController.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      // Login berhasil - REDIRECT KE HOME
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false, // Hapus semua route sebelumnya
      );
      
      // Tampilkan success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login berhasil!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Login gagal
      _showError(authController.errorMessage ?? 'Login gagal. Periksa email dan password Anda.');
    }
  }

  // FUNGSI SHOW ERROR
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/bg_login.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 64),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x802A67B1), Color(0xFF122B4B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const LogoCircle(),
                      const SizedBox(height: 20),
                      Text('Selamat Datang', style: AppTextStyles.titleWhite.copyWith(fontSize: 28)),
                      const SizedBox(height: 8),
                      Text('Masuk untuk melanjutkan', style: AppTextStyles.titleWhite.copyWith(fontSize: 14, color: Colors.white.withOpacity(0.8))),
                      const SizedBox(height: 36),

                      // Form Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email Input with Icon
                            const InputLabel('Email'),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: emailController,
                              hint: 'Masukkan email anda',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),

                            // Password Input with Toggle
                            const InputLabel('Password'),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: passwordController,
                              hint: 'Masukkan password anda',
                              icon: Icons.lock_outline,
                              obscure: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),

                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/setting_pass'),
                                child: Text(
                                  'Lupa Password?',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Login Button - MODIFIKASI INI
                            Consumer<AuthController>(
                              builder: (context, authController, child) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: authController.isLoading ? null : _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryBlue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                      disabledBackgroundColor: AppColors.primaryBlue.withOpacity(0.6),
                                    ),
                                    child: authController.isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : const Text(
                                            'Masuk',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Belum punya akun? ', style: AppTextStyles.titleWhite.copyWith(fontSize: 14, color: Colors.white.withOpacity(0.9))),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/signup'),
                            child: Text('Daftar', style: AppTextStyles.titleWhite.copyWith(fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}