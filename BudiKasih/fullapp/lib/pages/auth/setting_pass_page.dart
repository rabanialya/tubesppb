import 'package:flutter/material.dart';

import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

import '../../widgets/setting_pass/step_progress_indicator.dart';
import '../../widgets/setting_pass/step_email.dart';
import '../../widgets/setting_pass/step_verification.dart';
import '../../widgets/setting_pass/step_new_password.dart';
import '../../widgets/setting_pass/reset_header.dart';

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

  //--------------------------------------------
  // SNACKBAR
  //--------------------------------------------
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: AppTextStyles.fontFamily)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  //--------------------------------------------
  // NEXT STEP LOGIC
  //--------------------------------------------
  void _nextStep() {
    if (step == 1) {
      if (emailController.text.trim().isEmpty) {
        return _showSnackBar('Email harus diisi', Colors.orange);
      }
      if (!emailController.text.contains('@')) {
        return _showSnackBar('Format email tidak valid', Colors.red);
      }

      _showSnackBar('Kode verifikasi telah dikirim ke email Anda', Colors.green);
      setState(() => step = 2);

    } else if (step == 2) {
      if (kodeController.text.trim().isEmpty) {
        return _showSnackBar('Kode verifikasi harus diisi', Colors.orange);
      }
      if (kodeController.text.length != 6) {
        return _showSnackBar('Kode verifikasi harus 6 digit', Colors.orange);
      }

      _showSnackBar('Kode berhasil diverifikasi!', Colors.green);
      setState(() => step = 3);

    } else {
      if (newPassController.text.isEmpty || confirmPassController.text.isEmpty) {
        return _showSnackBar('Semua field harus diisi', Colors.orange);
      }
      if (newPassController.text.length < 6) {
        return _showSnackBar('Password minimal 6 karakter', Colors.orange);
      }
      if (newPassController.text != confirmPassController.text) {
        return _showSnackBar('Password tidak cocok', Colors.red);
      }

      //-----------------------------------
      // ALERT PASSWORD BERHASIL DIGANTI
      //-----------------------------------
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text(
                'Berhasil!',
                style: TextStyle(fontFamily: AppTextStyles.fontFamily),
              ),
            ],
          ),
          content: const Text(
            'Password Anda telah berhasil diubah. Silakan login dengan password baru.',
            style: TextStyle(
              height: 1.5,
              fontFamily: AppTextStyles.fontFamily,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Login Sekarang',
                style: TextStyle(fontFamily: AppTextStyles.fontFamily),
              ),
            ),
          ],
        ),
      );
    }
  }

  //--------------------------------------------
  // SUBTITLE TEXT
  //--------------------------------------------
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

  //--------------------------------------------
  // STEP VIEW
  //--------------------------------------------
  Widget _buildStepContent() {
    if (step == 1) {
      return StepEmail(
        controller: emailController,
        onNext: _nextStep,
      );
    } else if (step == 2) {
      return StepVerification(
        controller: kodeController,
        onNext: _nextStep,
        onResend: () {
          _showSnackBar('Kode verifikasi telah dikirim ulang', Colors.green);
        },
      );
    } else {
      return StepNewPassword(
        newPass: newPassController,
        confirmPass: confirmPassController,
        obscureNew: _obscureNewPass,
        obscureConfirm: _obscureConfirm,
        onToggleNew: () {
          setState(() => _obscureNewPass = !_obscureNewPass);
        },
        onToggleConfirm: () {
          setState(() => _obscureConfirm = !_obscureConfirm);
        },
        onSubmit: _nextStep,
      );
    }
  }

  //--------------------------------------------
  // BUILD MAIN UI
  //--------------------------------------------
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
                //--------------------------------------------
                // BACK BUTTON
                //--------------------------------------------
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

                //--------------------------------------------
                // MAIN CONTENT
                //--------------------------------------------
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(
                          children: [
                            ResetHeader(subtitle: _getSubtitle()),
                            const SizedBox(height: 32),

                            StepProgressIndicator(currentStep: step),
                            const SizedBox(height: 32),

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