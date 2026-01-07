import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userNamaKey = 'user_nama';
  static const String _userEmailKey = 'user_email';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveUser(int id, String nama, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, id);
    await prefs.setString(_userNamaKey, nama);
    await prefs.setString(_userEmailKey, email);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_userIdKey);
    final nama = prefs.getString(_userNamaKey);
    final email = prefs.getString(_userEmailKey);
    
    if (id != null && nama != null && email != null) {
      return {'id': id, 'nama': nama, 'email': email};
    }
    return null;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}