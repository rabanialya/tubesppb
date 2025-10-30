import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DonationCashPage extends StatefulWidget {
  const DonationCashPage({super.key});

  @override
  State<DonationCashPage> createState() => _DonationCashPageState();
}

class _DonationCashPageState extends State<DonationCashPage> {
  final _namaController = TextEditingController();
  final _hpController = TextEditingController();
  final _catatanController = TextEditingController();
  File? _buktiTransfer;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _buktiTransfer = File(pickedFile.path);
      });
    }
  }

  void _showTerimaKasihDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFE6EEF8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Terima Kasih!',
          style: TextStyle(
            color: Color(0xFF122B4B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Terima kasih atas donasi tunai Anda!\n'
          'Tim kami akan mengonfirmasi melalui WhatsApp dalam 1x24 jam.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF122B4B),
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Color(0xFF2A67B1)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EEF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A67B1),
        title: const Text('Donasi Tunai', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF122B4B),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.volunteer_activism), label: 'Donasi Sekarang'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Formulir Donasi Tunai',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF122B4B),
                ),
              ),
              const SizedBox(height: 20),
              
              TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _hpController,
                decoration: InputDecoration(
                  labelText: 'Nomor HP / WhatsApp',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Transfer ke rekening:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'BCA: 1234567890\nA.n. Yayasan Panti Wredha Budi Dharma',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Upload Bukti Transfer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF122B4B),
                ),
              ),
              const SizedBox(height: 8),
              
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: _buktiTransfer != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _buktiTransfer!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tap untuk memilih foto',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _catatanController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Catatan (opsional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_buktiTransfer == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mohon upload bukti transfer'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    _showTerimaKasihDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A67B1),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Kirim',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}