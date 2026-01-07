import 'dart:convert';
import 'package:http/http.dart' as http; // Pakai http langsung untuk debugging
import '../core/config/api_config.dart';
import '../core/storage/token_storage.dart';

class FeedbackService {
  
  /// SEND FEEDBACK - DEBUG VERSION
  static Future<Map<String, dynamic>> sendFeedback({
    required String pesan,
  }) async {
    try {
      // 1. Get user data
      final user = await TokenStorage.getUser();
      final token = await TokenStorage.getToken();
      
      print('🔍 DEBUG USER DATA:');
      print('- User: $user');
      print('- Token: ${token != null ? "${token.substring(0, 30)}..." : "NULL"}');
      print('- IsLoggedIn: ${await TokenStorage.isLoggedIn()}');

      if (user == null || token == null) {
        return {
          'success': false,
          'message': 'User belum login',
          'debug': 'user:$user, token:$token',
        };
      }

      // 2. Prepare data - SESUAIKAN DENGAN LARAVEL ANDA
      final feedbackData = {
        'user_id': user['id'],       // Sesuaikan field name
        'nama': user['nama'],        // Sesuaikan field name  
        'email': user['email'],      // Sesuaikan field name
        'telepon': user['telepon'] ?? '', // Jika ada
        'pesan': pesan,
        'tanggal': DateTime.now().toIso8601String().split('T')[0],
        'jam': DateTime.now().toIso8601String().split('T')[1].split('.')[0],
        'status': 'unread',
      };

      print('📤 DATA YANG DIKIRIM:');
      print(feedbackData);
      print('🌐 ENDPOINT: ${ApiConfig.feedback}');

      // 3. Send using http client langsung untuk debug
      final response = await http.post(
        Uri.parse(ApiConfig.feedback),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Sesuaikan dengan Laravel
        },
        body: jsonEncode(feedbackData),
      );

      print('📥 RESPONSE DARI LARAVEL:');
      print('- Status Code: ${response.statusCode}');
      print('- Body: ${response.body}');
      print('- Headers: ${response.headers}');

      // 4. Parse response
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Pesan berhasil dikirim',
          'data': data,
          'debug': {
            'statusCode': response.statusCode,
            'response': data,
          }
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengirim pesan (${response.statusCode})',
          'debug': {
            'statusCode': response.statusCode,
            'response': data,
          }
        };
      }

    } catch (e, stackTrace) {
      print('❌ ERROR DETAIL:');
      print('- Error: $e');
      print('- StackTrace: $stackTrace');
      
      return {
        'success': false,
        'message': 'Koneksi error: $e',
        'debug': {
          'error': e.toString(),
          'stack': stackTrace.toString(),
        }
      };
    }
  }
}