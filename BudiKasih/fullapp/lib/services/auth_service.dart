import 'dart:convert';
import '../core/network/api_client.dart';
import '../core/config/api_config.dart';
import '../core/storage/token_storage.dart';
import '../models/user_model.dart';

class AuthService {

  /// =====================
  /// REGISTER - SESUAI LARAVEL
  /// =====================
  Future<Map<String, dynamic>> register({
    required String nama,  // ✅ PAKAI 'nama' sesuai Laravel
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.post(
        ApiConfig.register,
        {
          'nama': nama,  // ✅ Laravel pakai 'nama'
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );

      final data = jsonDecode(response.body);

      print('REGISTER RESPONSE: $data');

      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Register gagal',
          'errors': data['errors'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  /// =====================
  /// LOGIN
  /// =====================
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.post(
        ApiConfig.login,
        {
          'email': email,
          'password': password,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['data'] != null) {
        final token = data['data']['token'];
        final user = UserModel.fromJson(data['data']['user']);

        await TokenStorage.saveToken(token);
        await TokenStorage.saveUser(
          user.id,
          user.nama,
          user.email,
        );

        return {
          'success': true,
          'data': data,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Login gagal',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }



  /// =====================
  /// LOGOUT
  /// =====================
  Future<void> logout() async {
    try {
      await ApiClient.post(
        ApiConfig.logout,
        {},
        needsAuth: true,
      );
    } finally {
      await TokenStorage.clearAll();
    }
  }

  /// =====================
  /// PROFILE
  /// =====================
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await ApiClient.get(
        ApiConfig.profile,
        needsAuth: true,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data,
        };
      }

      return {
        'success': false,
        'message': 'Gagal mengambil profil',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
}