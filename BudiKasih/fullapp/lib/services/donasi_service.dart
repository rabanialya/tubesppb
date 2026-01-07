import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/donasi_model.dart';

class DonasiService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> createDonation({
    required String donatur,
    required String jenis,
    required String detail,
    required String jumlah,
    String? catatan,
    String? buktiBase64,
    int? userId,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      final currentUserId =
          userId ?? (currentUser != null ? int.tryParse(currentUser.id) : null);

      // ===============================
      // NORMALISASI JENIS (WAJIB)
      // ===============================
      final jenisLower = jenis.toLowerCase().trim();
      late String jenisNormalized;
      late String statusNormalized;

      if (jenisLower == 'barang') {
        jenisNormalized = 'Barang';
        statusNormalized = 'Langsung';
      } else if (jenisLower == 'tunai') {
        jenisNormalized = 'Tunai';
        statusNormalized = 'Tidak Langsung';
      } else {
        return {
          'success': false,
          'message': 'Jenis donasi harus Barang atau Tunai',
        };
      }

      final data = {
        'user_id': currentUserId,
        'donatur': donatur,
        'jenis': jenisNormalized,          // Barang / Tunai
        'detail': detail,
        'jumlah': jumlah,
        'tanggal': DateTime.now()
            .toIso8601String()
            .split('T')[0],
        'status': statusNormalized,        // Langsung / Tidak Langsung
        'status_verifikasi': 'pending',
        'catatan': catatan ?? '',
        'bukti': buktiBase64,
      };

      final result = await _supabase
          .from('donasi')
          .insert(data)
          .select()
          .single();

      return {
        'success': true,
        'data': result,
        'message': 'Donasi berhasil dikirim',
      };
    } on PostgrestException catch (e) {
      return {
        'success': false,
        'message': 'Error database: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // =====================================
  // GET DONASI
  // =====================================
  Future<Map<String, dynamic>> getDonations({String? jenis}) async {
    try {
      var query = _supabase.from('donasi').select();

      if (jenis != null) {
        final jenisLower = jenis.toLowerCase().trim();
        final jenisNormalized =
            jenisLower == 'barang' ? 'Barang' : 'Tunai';
        query = query.eq('jenis', jenisNormalized);
      }

      final result = await query
          .isFilter('deleted_at', null)
          .order('created_at', ascending: false);

      final List<DonasiModel> donations = (result as List)
          .map((e) => DonasiModel.fromJson(e))
          .toList();

      return {
        'success': true,
        'data': donations,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // =====================================
  // GET BY ID
  // =====================================
  Future<Map<String, dynamic>> getDonationById(int id) async {
    try {
      final result = await _supabase
          .from('donasi')
          .select()
          .eq('id', id)
          .single();

      return {
        'success': true,
        'data': DonasiModel.fromJson(result),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // =====================================
  // UPDATE
  // =====================================
  Future<Map<String, dynamic>> updateDonation({
    required int id,
    String? statusVerifikasi,
    String? petugas,
  }) async {
    try {
      final Map<String, dynamic> updateBody = {};

      if (statusVerifikasi != null) {
        updateBody['status_verifikasi'] = statusVerifikasi;
      }

      if (petugas != null) {
        updateBody['petugas'] = petugas;
      }

      final result = await _supabase
          .from('donasi')
          .update(updateBody)
          .eq('id', id)
          .select()
          .single();

      return {
        'success': true,
        'data': result,
        'message': 'Update berhasil',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // =====================================
  // DELETE (SOFT DELETE)
  // =====================================
  Future<Map<String, dynamic>> deleteDonation(int id) async {
    try {
      await _supabase.from('donasi').update({
        'deleted_at': DateTime.now().toIso8601String(),
      }).eq('id', id);

      return {
        'success': true,
        'message': 'Donasi berhasil dihapus',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}
