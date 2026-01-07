import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// =====================
  /// REGISTER
  /// =====================
  Future<bool> register({
    required String nama,
    required String email,
    required String password,
  }) async {
    setLoading(true);
    _errorMessage = null;

    try {
      final result = await _authService.register(
        nama: nama,  // ✅ Gunakan 'nama' konsisten
        email: email,
        password: password,
      );

      if (result['success'] == true) {
        _user = UserModel.fromJson(result['data']['data']['user']);
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// =====================
  /// LOGIN
  /// =====================
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    setLoading(true);
    _errorMessage = null;

    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );

      if (result['success'] == true) {
        final data = result['data'];

        if (data != null && data['data'] != null) {
          _user = UserModel.fromJson(data['data']['user']);
        }

        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// =====================
  /// LOGOUT
  /// =====================
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  /// =====================
  /// LOAD PROFILE
  /// =====================
  Future<void> loadProfile() async {
    final result = await _authService.getProfile();
    if (result['success'] == true) {
      _user = UserModel.fromJson(result['data']['user']);
      notifyListeners();
    }
  }
}