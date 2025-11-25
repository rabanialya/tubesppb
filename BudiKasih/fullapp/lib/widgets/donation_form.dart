import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../themes/text_styles.dart';

class DonationForm extends StatelessWidget {
  final TextEditingController namaController;
  final TextEditingController hpController;
  final TextEditingController barangController;
  final TextEditingController jumlahController;
  final TextEditingController tanggalController;
  final TextEditingController catatanController;
  final VoidCallback onSubmit;

  const DonationForm({
    super.key,
    required this.namaController,
    required this.hpController,
    required this.barangController,
    required this.jumlahController,
    required this.tanggalController,
    required this.catatanController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Form Donasi Barang', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkBlue)),
              const SizedBox(height: 12),

              // Nama
              Text('Nama', style: const TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  hintText: 'Nama lengkap',
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // HP
              Text('Nomor HP', style: const TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: hpController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '08xx xxxx xxxx',
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // Jenis Barang
              Text('Jenis Barang', style: const TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: barangController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Pampers Dewasa Size L',
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // Jumlah
              Text('Jumlah', style: const TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Jumlah barang',
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // Tanggal
              Text('Tanggal', style: const TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: tanggalController,
                decoration: InputDecoration(
                  hintText: 'DD-MM-YYYY',
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // Catatan
              Text('Catatan (opsional)', style: const TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: catatanController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Catatan untuk admin',
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Kirim Donasi', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}