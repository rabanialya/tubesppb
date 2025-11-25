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

  // ⬅️ Tambahan fungsi untuk date picker
  final VoidCallback? onPickDate;

  const DonationForm({
    super.key,
    required this.namaController,
    required this.hpController,
    required this.barangController,
    required this.jumlahController,
    required this.tanggalController,
    required this.catatanController,
    required this.onSubmit,
    this.onPickDate, // ⬅️ tambahan
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Form Donasi Barang',
                style: AppTextStyles.heading.copyWith(fontSize: 16, color: AppColors.darkBlue),
              ),
              const SizedBox(height: 12),

              // Nama
              Text(
                'Nama',
                style: AppTextStyles.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkBlue),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  hintText: 'Nama lengkap',
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // HP
              Text(
                'Nomor HP',
                style: AppTextStyles.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkBlue),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: hpController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '08xx xxxx xxxx',
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // Jenis Barang
              Text(
                'Jenis Barang',
                style: AppTextStyles.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkBlue),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: barangController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Pampers Dewasa Size L',
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // Jumlah
              Text(
                'Jumlah',
                style: AppTextStyles.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkBlue),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Jumlah barang',
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // Tanggal — sudah ada DatePicker
              Text(
                'Tanggal',
                style: AppTextStyles.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkBlue),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: tanggalController,
                readOnly: true, // ⬅️ user wajib pilih dari datepicker
                onTap: onPickDate, // ⬅️ panggil datepicker
                decoration: InputDecoration(
                  hintText: 'DD-MM-YYYY',
                  filled: true,
                  fillColor: Colors.grey[50],
                  suffixIcon: const Icon(Icons.calendar_month), // ⬅️ icon kalender
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // Catatan
              Text(
                'Catatan (opsional)',
                style: AppTextStyles.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkBlue),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: catatanController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Catatan untuk admin',
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Kirim Donasi', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}