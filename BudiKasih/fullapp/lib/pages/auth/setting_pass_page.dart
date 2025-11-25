import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/step_progress_indicator.dart';

class SettingPassPage extends StatefulWidget {
  const SettingPassPage({super.key});

  @override
  State<SettingPassPage> createState() => _SettingPassPageState();
}

class _SettingPassPageState extends State<SettingPassPage> {
  int step = 1;
  final emailController = TextEditingController();
  final kodeController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();
  bool _obscureNewPass = true;
  bool _obscureConfirm = true;

  void _nextStep() {
    if (step == 1) {
      if (emailController.text.trim().isEmpty) {
        _showSnackBar('Email harus diisi', Colors.orange);
        return;
      }
      if (!emailController.text.contains('@')) {
        _showSnackBar('Format email tidak valid', Colors.red);
        return;
      }
      _showSnackBar('Kode verifikasi telah dikirim ke email Anda', Colors.green);
      setState(() => step = 2);
    } else if (step == 2) {
      if (kodeController.text.trim().isEmpty) {
        _showSnackBar('Kode verifikasi harus diisi', Colors.orange);
        return;
      }
      if (kodeController.text.length != 6) {
        _showSnackBar('Kode verifikasi harus 6 digit', Colors.orange);
        return;
      }
      _showSnackBar('Kode verifikasi berhasil!', Colors.green);
      setState(() => step = 3);
    } else {
      if (newPassController.text.isEmpty || confirmPassController.text.isEmpty) {
        _showSnackBar('Semua field harus diisi', Colors.orange);
        return;
      }
      if (newPassController.text.length < 6) {
        _showSnackBar('Password minimal 6 karakter', Colors.orange);
        return;
      }
      if (newPassController.text != confirmPassController.text) {
        _showSnackBar('Password tidak cocok', Colors.red);
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text('Berhasil!'),
            ],
          ),
          content: const Text(
            'Password Anda telah berhasil diubah. Silakan login dengan password baru.',
            style: TextStyle(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Login Sekarang'),
            ),
          ],
        ),
      );
    }
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

  String _getSubtitle() {
    switch (step) {
      case 1:
        return 'Masukkan email Anda untuk menerima kode verifikasi';
      case 2:
        return 'Masukkan kode 6 digit yang telah dikirim ke email Anda';
      case 3:
        return 'Buat password baru untuk akun Anda';
      default:
        return '';
    }
  }

  Widget _buildStepContent() {
    switch (step) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: emailController,
          hint: 'Masukkan email anda',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Kirim Kode',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kode Verifikasi',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: kodeController,
          hint: '000000',
          icon: Icons.pin_outlined,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tidak menerima kode? ',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            GestureDetector(
              onTap: () {
                _showSnackBar('Kode verifikasi telah dikirim ulang', Colors.green);
              },
              child: const Text(
                'Kirim Ulang',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 13,
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Verifikasi',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password Baru',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: newPassController,
          hint: 'Minimal 6 karakter',
          icon: Icons.lock_outline,
          obscure: _obscureNewPass,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureNewPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: Colors.grey[600],
            ),
            onPressed: () {
              setState(() {
                _obscureNewPass = !_obscureNewPass;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Konfirmasi Password',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: confirmPassController,
          hint: 'Ulangi password baru',
          icon: Icons.lock_outline,
          obscure: _obscureConfirm,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: Colors.grey[600],
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
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Simpan Perubahan',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
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
            child: Column(
              children: [
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Main Content
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                              ),
                              child: const Icon(
                                Icons.lock_reset,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Reset Password',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getSubtitle(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Progress Indicator
                            StepProgressIndicator(currentStep: step),
                            const SizedBox(height: 32),

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
                              child: _buildStepContent(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}