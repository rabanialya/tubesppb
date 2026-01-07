// lib/services/setting_pass_service.dart

import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/setting_pass_model.dart';

class SettingPassService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Generate 6 digit random code
  String _generateToken() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  //--------------------------------------------
  // STEP 1: Send verification code
  //--------------------------------------------
  Future<Map<String, dynamic>> sendVerificationCode(String email) async {
    try {
      // Validasi email format
      if (!email.contains('@')) {
        return {
          'success': false,
          'message': 'Format email tidak valid',
        };
      }

      // Generate token
      final token = _generateToken();

      // Delete token lama untuk email ini (jika ada)
      await _supabase
          .from('password_reset_tokens')
          .delete()
          .eq('email', email);

      // Insert token baru
      await _supabase.from('password_reset_tokens').insert({
        'email': email,
        'token': token,
        'created_at': DateTime.now().toIso8601String(),
      });

      // TODO: Kirim email dengan token
      // Untuk development, print token di console
      print('🔐 Verification code for $email: $token');

      return {
        'success': true,
        'message': 'Kode verifikasi telah dikirim ke email Anda',
        'token': token, // Hanya untuk development, hapus di production!
      };
    } catch (e) {
      print('Error sending verification code: $e');
      return {
        'success': false,
        'message': 'Gagal mengirim kode verifikasi: ${e.toString()}',
      };
    }
  }

  //--------------------------------------------
  // STEP 2: Verify code
  //--------------------------------------------
  Future<Map<String, dynamic>> verifyCode(String email, String code) async {
    try {
      // Ambil token dari database
      final response = await _supabase
          .from('password_reset_tokens')
          .select()
          .eq('email', email)
          .eq('token', code)
          .maybeSingle();

      if (response == null) {
        return {
          'success': false,
          'message': 'Kode verifikasi tidak valid',
        };
      }

      // Parse token
      final resetToken = PasswordResetToken.fromJson(response);

      // Check apakah sudah expired
      if (resetToken.isExpired()) {
        // Delete token yang expired
        await _supabase
            .from('password_reset_tokens')
            .delete()
            .eq('email', email);

        return {
          'success': false,
          'message': 'Kode verifikasi sudah kadaluarsa. Silakan minta kode baru.',
        };
      }

      return {
        'success': true,
        'message': 'Kode berhasil diverifikasi!',
      };
    } catch (e) {
      print('Error verifying code: $e');
      return {
        'success': false,
        'message': 'Gagal memverifikasi kode: ${e.toString()}',
      };
    }
  }

  //--------------------------------------------
  // STEP 3: Reset password - UPDATE AUTH USER
  //--------------------------------------------
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      // Verify code sekali lagi untuk keamanan
      final verifyResult = await verifyCode(email, code);
      if (!verifyResult['success']) {
        return verifyResult;
      }

      // Method 1: Update password langsung via Supabase Auth
      // Ini akan update password user yang sedang login
      // Untuk user yang belum login, kita perlu cara lain
      
      try {
        // Coba update via auth (jika user punya session)
        await _supabase.auth.updateUser(
          UserAttributes(password: newPassword),
        );
        
        // Delete token setelah berhasil reset
        await _supabase
            .from('password_reset_tokens')
            .delete()
            .eq('email', email);

        return {
          'success': true,
          'message': 'Password berhasil diubah!',
        };
      } catch (updateError) {
        print('Cannot update directly, trying password reset email...');
        
        // Method 2: Fallback - Kirim email reset password dari Supabase
        // Ini akan kirim link reset password ke email user
        await _supabase.auth.resetPasswordForEmail(
          email,
          redirectTo: 'YOUR_APP_DEEP_LINK://reset-password',
        );
        
        // Delete token karena sudah diverifikasi
        await _supabase
            .from('password_reset_tokens')
            .delete()
            .eq('email', email);
            
        return {
          'success': true,
          'message': 'Kode berhasil diverifikasi! Link reset password telah dikirim ke email Anda.',
          'useEmailLink': true,
        };
      }
    } catch (e) {
      print('Error resetting password: $e');
      return {
        'success': false,
        'message': 'Gagal mereset password. Silakan coba lagi.',
      };
    }
  }

  //--------------------------------------------
  // Helper: Resend code
  //--------------------------------------------
  Future<Map<String, dynamic>> resendCode(String email) async {
    return await sendVerificationCode(email);
  }

  //--------------------------------------------
  // Helper: Clean expired tokens (jalankan berkala)
  //--------------------------------------------
  Future<void> cleanExpiredTokens() async {
    try {
      final fifteenMinutesAgo = DateTime.now()
          .subtract(const Duration(minutes: 15))
          .toIso8601String();

      await _supabase
          .from('password_reset_tokens')
          .delete()
          .lt('created_at', fifteenMinutesAgo);
    } catch (e) {
      print('Error cleaning expired tokens: $e');
    }
  }
}