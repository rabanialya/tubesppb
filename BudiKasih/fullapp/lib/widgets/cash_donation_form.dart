import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../themes/colors.dart';
import '../themes/text_styles.dart';

class CashDonationForm extends StatefulWidget {
  final TextEditingController namaController;
  final TextEditingController hpController;
  final TextEditingController nominalController;
  final TextEditingController catatanController;
  final VoidCallback onSubmit;

  const CashDonationForm({
    super.key,
    required this.namaController,
    required this.hpController,
    required this.nominalController,
    required this.catatanController,
    required this.onSubmit,
  });

  @override
  State<CashDonationForm> createState() => _CashDonationFormState();
}

class _CashDonationFormState extends State<CashDonationForm> {
  File? _buktiTransfer;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) {
      setState(() => _buktiTransfer = File(f.path));
    }
  }

  // expose image to parent via callback? original logic kept internal
  File? get currentBukti => _buktiTransfer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // container card
        Container(
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
                  const Text(
                    'Informasi Donatur',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildFormField(
                'Nama Lengkap',
                widget.namaController,
                Icons.person_outline,
                'Masukkan nama Anda',
              ),
              _buildFormField(
                'Nomor HP / WhatsApp',
                widget.hpController,
                Icons.phone,
                '08xxxxxxxxxx',
                keyboardType: TextInputType.phone,
              ),
              _buildFormField(
                'Nominal Donasi',
                widget.nominalController,
                Icons.attach_money,
                'Contoh: 100000',
                keyboardType: TextInputType.number,
              ),
              _buildFormField(
                'Catatan',
                widget.catatanController,
                Icons.note,
                'Pesan atau catatan (opsional)',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              const Text(
                'Upload Bukti Transfer',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBlue,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
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
                              Image.file(_buktiTransfer!, fit: BoxFit.cover, width: double.infinity),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.edit, color: Colors.white, size: 18),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, color: Colors.grey[400], size: 48),
                            const SizedBox(height: 12),
                            Text(
                              'Tap untuk memilih foto',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Screenshot atau foto bukti transfer',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.grey[500],
                                fontSize: 11,
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
                    children: const [
                      Icon(Icons.send, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Kirim Donasi',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    IconData icon,
    String hint, {
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
                style: const TextStyle(
                  fontFamily: 'Poppins',
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
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}