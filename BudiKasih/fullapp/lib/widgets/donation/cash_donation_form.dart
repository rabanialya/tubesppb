import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

class CashDonationForm extends StatefulWidget {
  final TextEditingController namaController;
  final TextEditingController emailController;
  final TextEditingController hpController;
  final TextEditingController nominalController;
  final TextEditingController catatanController;
  final VoidCallback onSubmit;

  const CashDonationForm({
    Key? key,
    required this.namaController,
    required this.emailController,
    required this.hpController,
    required this.nominalController,
    required this.catatanController,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<CashDonationForm> createState() => _CashDonationFormState();
}

class _CashDonationFormState extends State<CashDonationForm> {
  File? _buktiTransfer;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _buktiTransfer = File(file.path);
      });
    }
  }

  File? get currentBukti => _buktiTransfer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note, color: AppColors.primaryBlue, size: 24),
              const SizedBox(width: 10),
              Text(
                'Informasi Donatur',
                style: AppTextStyles.heading.copyWith(
                  fontSize: 16,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildFormField(
            label: 'Nama',
            controller: widget.namaController,
            icon: Icons.person_outline,
            hint: 'Masukkan nama Anda',
          ),

          _buildFormField(
            label: 'Email',
            controller: widget.emailController,
            icon: Icons.email_outlined,
            hint: 'Masukkan email Anda',
          ),

          _buildFormField(
            label: 'Nomor HP',
            controller: widget.hpController,
            icon: Icons.phone,
            hint: '08xxxxxxxxxx',
            keyboardType: TextInputType.phone,
          ),

          _buildFormField(
            label: 'Nominal Donasi',
            controller: widget.nominalController,
            icon: Icons.attach_money,
            hint: 'Contoh: 100000',
            keyboardType: TextInputType.number,
          ),

          _buildFormField(
            label: 'Catatan',
            controller: widget.catatanController,
            icon: Icons.note,
            hint: 'Pesan atau catatan (opsional)',
            maxLines: 3,
          ),

          const SizedBox(height: 20),
          Text(
            'Upload Bukti Transfer',
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child: _buktiTransfer != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Image.file(
                            _buktiTransfer!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Colors.grey[400],
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tap untuk memilih foto',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Screenshot atau foto bukti transfer',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Kirim Donasi',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryBlue, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.body.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.body.copyWith(
                color: Colors.grey[400],
                fontSize: 13,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primaryBlue,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}