import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';

import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

import '../../widgets/auth/logo_circle.dart';
import '../../widgets/auth/custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _namaController = TextEditingController();  // ✅ PAKAI 'nama'
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  /// =====================
  /// REGISTER - SESUAI LARAVEL
  /// =====================
  void _register() async {
    if (_namaController.text.trim().isEmpty) {
      _showSnackBar('Nama lengkap harus diisi', Colors.orange);
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showSnackBar('Email harus diisi', Colors.orange);
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showSnackBar('Password harus diisi', Colors.orange);
      return;
    }
    if (_passwordController.text.length < 6) {
      _showSnackBar('Password minimal 6 karakter', Colors.orange);
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      _showSnackBar('Password dan konfirmasi tidak cocok', Colors.red);
      return;
    }

    final authController = context.read<AuthController>();

    final success = await authController.register(
      nama: _namaController.text.trim(),  // ✅ PAKAI 'nama' sesuai Laravel
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/login');
      _showSnackBar(
        'Akun berhasil dibuat! Silakan login',
        Colors.green,
      );
    } else {
      _showSnackBar(
        authController.errorMessage ?? 'Register gagal',
        Colors.red,
      );
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
            image: AssetImage('assets/img/bg_signup.jpg'),
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
                      Text(
                        'Buat Akun Baru',
                        style: AppTextStyles.titleWhite.copyWith(fontSize: 28),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bergabunglah dengan kami',
                        style: AppTextStyles.titleWhite.copyWith(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // FORM
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Nama Lengkap'),
                            CustomTextField(
                              controller: _namaController,  // ✅ PAKAI 'nama'
                              hint: 'Masukkan nama lengkap',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 16),

                            _label('Email'),
                            CustomTextField(
                              controller: _emailController,
                              hint: 'Masukkan email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),

                            _label('Password'),
                            CustomTextField(
                              controller: _passwordController,
                              hint: 'Minimal 6 karakter',
                              icon: Icons.lock_outline,
                              obscure: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 16),

                            _label('Konfirmasi Password'),
                            CustomTextField(
                              controller: _confirmController,
                              hint: 'Ulangi password',
                              icon: Icons.lock_outline,
                              obscure: _obscureConfirm,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirm = !_obscureConfirm;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text(
                          'Sudah punya akun? Masuk',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
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

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.darkBlue,
        ),
      ),
    );
  }
}