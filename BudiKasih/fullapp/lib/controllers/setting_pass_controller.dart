// lib/controllers/setting_pass_controller.dart

import 'package:flutter/material.dart';
import '../services/setting_pass_service.dart';

class SettingPassController extends ChangeNotifier {
  final SettingPassService _service = SettingPassService();
  
  String? _email;
  String? _verificationCode;
  bool _isLoading = false;

  // Getters
  String? get email => _email;
  String? get verificationCode => _verificationCode;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  //--------------------------------------------
  // STEP 1: Send verification code
  //--------------------------------------------
  Future<Map<String, dynamic>> sendVerificationCode(String email) async {
    _setLoading(true);
    _email = email;
    final result = await _service.sendVerificationCode(email);
    _setLoading(false);
    return result;
  }

  //--------------------------------------------
  // STEP 2: Verify code
  //--------------------------------------------
  Future<Map<String, dynamic>> verifyCode(String code) async {
    if (_email == null) {
      return {
        'success': false,
        'message': 'Email tidak ditemukan. Silakan mulai dari awal.',
      };
    }

    _setLoading(true);
    final result = await _service.verifyCode(_email!, code);
    _setLoading(false);
    
    if (result['success']) {
      _verificationCode = code;
    }
    
    return result;
  }

  //--------------------------------------------
  // STEP 3: Reset password
  //--------------------------------------------
  Future<Map<String, dynamic>> resetPassword(String newPassword) async {
    if (_email == null || _verificationCode == null) {
      return {
        'success': false,
        'message': 'Data tidak lengkap. Silakan mulai dari awal.',
      };
    }

    _setLoading(true);
    final result = await _service.resetPassword(
      email: _email!,
      code: _verificationCode!,
      newPassword: newPassword,
    );
    _setLoading(false);
    
    return result;
  }

  //--------------------------------------------
  // Helper: Resend code
  //--------------------------------------------
  Future<Map<String, dynamic>> resendCode() async {
    if (_email == null) {
      return {
        'success': false,
        'message': 'Email tidak ditemukan',
      };
    }
    
    _setLoading(true);
    final result = await _service.resendCode(_email!);
    _setLoading(false);
    
    return result;
  }

  //--------------------------------------------
  // Reset controller state
  //--------------------------------------------
  void reset() {
    _email = null;
    _verificationCode = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}