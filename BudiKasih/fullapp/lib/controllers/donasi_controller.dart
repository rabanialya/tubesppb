import 'package:flutter/material.dart';
import '../services/donasi_service.dart';
import '../models/donasi_model.dart';

class DonasiController extends ChangeNotifier {
  final DonasiService _service = DonasiService();

  bool _isLoading = false;
  String? _errorMessage;
  List<DonasiModel> _donations = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<DonasiModel> get donations => _donations;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> createDonationBarang({
    required String donatur,
    required String email,
    required String hp,
    required String barang,
    required String jumlah,
    String? catatan,
    String? fotoBase64,
    String? buktiBase64,
    int? userId,
  }) async {
    setLoading(true);
    _errorMessage = null;

    try {
      final result = await _service.createDonation(
        donatur: '$donatur',
        jenis: 'barang', // Akan dinormalisasi jadi "Barang" di service
        detail: barang,
        jumlah: jumlah,
        catatan: catatan,
        buktiBase64: fotoBase64,
        userId: userId,
      );

      if (result['success'] == true) {
        await loadDonations();
        return true;
      } else {
        _errorMessage = result['message'];
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> createDonationTunai({
    required String donatur,
    required String email,
    required String hp,
    required String nominal,
    required String metode,
    String? catatan,
    String? buktiBase64, // <-- GANTI NAMA PARAMETER DARI buktiTransferBase64 JADI buktiBase64
    int? userId,
  }) async {
    setLoading(true);
    _errorMessage = null;

    try {
      final result = await _service.createDonation(
        donatur: '$donatur',
        jenis: 'Tunai', // Akan dinormalisasi jadi "Tunai" di service
        detail: metode,
        jumlah: nominal,
        catatan: catatan,
        buktiBase64: buktiBase64, // <-- GANTI JADI buktiBase64
        userId: userId,
      );

      if (result['success'] == true) {
        await loadDonations();
        return true;
      } else {
        _errorMessage = result['message'];
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadDonations({String? jenis}) async {
    setLoading(true);
    _errorMessage = null;

    try {
      final result = await _service.getDonations(jenis: jenis);
      if (result['success'] == true) {
        _donations = List<DonasiModel>.from(result['data'] ?? []);
      } else {
        _errorMessage = result['message'];
        _donations = [];
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      _donations = [];
    } finally {
      setLoading(false);
    }
  }

  Future<DonasiModel?> getDonationById(int id) async {
    setLoading(true);
    _errorMessage = null;

    try {
      final result = await _service.getDonationById(id);
      if (result['success'] == true) {
        return result['data'] as DonasiModel;
      } else {
        _errorMessage = result['message'];
        return null;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return null;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> updateDonationStatus({
    required int id,
    required String statusVerifikasi,
    String? petugas,
  }) async {
    setLoading(true);
    _errorMessage = null;

    try {
      final result = await _service.updateDonation(
        id: id,
        statusVerifikasi: statusVerifikasi,
        petugas: petugas,
      );

      if (result['success'] == true) {
        await loadDonations();
        return true;
      } else {
        _errorMessage = result['message'];
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> deleteDonation(int id) async {
    setLoading(true);
    _errorMessage = null;

    try {
      final result = await _service.deleteDonation(id);
      if (result['success'] == true) {
        await loadDonations();
        return true;
      } else {
        _errorMessage = result['message'];
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      setLoading(false);
    }
  }

  List<DonasiModel> getDonationsByJenis(String jenis) {
    // Normalisasi jenis untuk pencarian
    final jenisNormalized = jenis.toLowerCase() == 'barang' ? 'Barang' : 'Tunai';
    return _donations.where((d) => d.jenis == jenisNormalized).toList();
  }

  List<DonasiModel> getDonationsByStatus(String status) {
    return _donations.where((d) => d.statusVerifikasi == status).toList();
  }

  int getTotalDonations() => _donations.length;

  int getTotalBarang() => getDonationsByJenis('Barang').length;

  int getTotalTunai() => getDonationsByJenis('Tunai').length;

  int getTotalPending() => getDonationsByStatus('pending').length;

  int getTotalVerified() => getDonationsByStatus('verified').length;

  double getTotalNominalTunai() {
    return getDonationsByJenis('Tunai').fold(0.0, (sum, item) {
      final jumlahStr = item.jumlah.toString();
      final jumlahValue = double.tryParse(jumlahStr) ?? 0.0;
      return sum + jumlahValue;
    });
  }
}