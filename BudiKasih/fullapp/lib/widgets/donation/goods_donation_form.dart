import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

class GoodsDonationForm extends StatefulWidget {
  final TextEditingController namaController;
  final TextEditingController emailController;
  final TextEditingController hpController;
  final TextEditingController barangController;
  final TextEditingController jumlahController;
  final TextEditingController catatanController;
  final VoidCallback onSubmit;

  const GoodsDonationForm({
    super.key,
    required this.namaController,
    required this.emailController,
    required this.hpController,
    required this.barangController,
    required this.jumlahController,
    required this.catatanController,
    required this.onSubmit,
  });

  @override
  State<GoodsDonationForm> createState() => _GoodsDonationFormState();
}

class _GoodsDonationFormState extends State<GoodsDonationForm> {
  File? _bukti;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) {
      setState(() => _bukti = File(f.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Form Donasi Barang',
            style: AppTextStyles.heading.copyWith(
              fontSize: 18,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 20),

          _input('Nama', 'Nama lengkap', widget.namaController),
          _input('Email', 'Email aktif', widget.emailController,
              type: TextInputType.emailAddress),
          _input('Nomor HP', '08xx xxxx xxxx', widget.hpController,
              type: TextInputType.phone),
          _input('Jenis Barang', 'Contoh: Pampers Dewasa', widget.barangController),
          _input('Jumlah', 'Jumlah barang', widget.jumlahController,
              type: TextInputType.text),
          _input(
            'Catatan (opsional)',
            'Catatan untuk admin',
            widget.catatanController,
            maxLines: 3,
          ),

          const SizedBox(height: 16),
          Text(
            'Upload Bukti Pengiriman',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: _bukti == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap untuk pilih foto',
                          style: AppTextStyles.body.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        _bukti!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
              child: Text(
                'Kirim Donasi',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: type,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: AppColors.primaryBlue, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}