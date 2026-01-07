import 'package:flutter/material.dart';

class GoodsDonationForm extends StatelessWidget {
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
          Text(
            'Form Donasi Barang',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 20),
          
          _buildTextField('Nama Donatur', 'Masukkan nama lengkap', namaController),
          const SizedBox(height: 12),
          
          _buildTextField('Email', 'contoh@email.com', emailController, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 12),
          
          _buildTextField('Nomor HP', '08xxx', hpController, keyboardType: TextInputType.phone),
          const SizedBox(height: 12),
          
          _buildTextField('Jenis Barang', 'Contoh: Pampers, Sabun, dll', barangController),
          const SizedBox(height: 12),
          
          _buildTextField('Jumlah', 'Contoh: 5 bungkus, 10 buah', jumlahController),
          const SizedBox(height: 12),
          
          _buildTextField('Catatan (opsional)', 'Tambahkan catatan jika perlu', catatanController, maxLines: 3),
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Submit Donasi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}