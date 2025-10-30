import 'package:flutter/material.dart';

class DonationGoodsPage extends StatefulWidget {
  const DonationGoodsPage({super.key});

  @override
  State<DonationGoodsPage> createState() => _DonationGoodsPageState();
}

class _DonationGoodsPageState extends State<DonationGoodsPage> {
  bool showForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EEF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A67B1),
        title: const Text('Donasi Barang'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: showForm ? _buildDonationForm() : _buildNeedsList(),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF122B4B),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 0,
        onTap: (index) {
          // nanti bisa diarahkan ke halaman lain
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.volunteer_activism), label: 'Donasi Sekarang'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  // 🔹 Halaman pertama: daftar kebutuhan panti
  Widget _buildNeedsList() {
    final needs = [
      ['Pampers size L', '5 bungkus', 'Dibutuhkan'],
      ['Pampers size M', '3 bungkus', 'Dibutuhkan'],
      ['Minyak telon', '10 botol', 'Dibutuhkan'],
      ['Sabun mandi', '6 bungkus', 'Dibutuhkan'],
      ['Detergen', '10 bungkus', 'Dibutuhkan'],
      ['Tisu kering', '10 buah', 'Dibutuhkan'],
      ['Sikat gigi', '8 buah', 'Dibutuhkan'],
      ['Tepung beras', '5 bungkus', 'Dibutuhkan'],
      ['Blus lansia', '5 pasang', 'Dibutuhkan'],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Memberi dengan kasih, menerima dengan syukur 💙\n'
          'Setiap barang yang kamu donasikan akan sangat berarti bagi para Oma dan Opa di panti.\n\n'
          'Berikut kebutuhan paling mendesak saat ini:',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF122B4B),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Barang')),
              DataColumn(label: Text('Kebutuhan')),
              DataColumn(label: Text('Status')),
            ],
            rows: needs
                .map(
                  (item) => DataRow(
                    cells: item
                        .map((val) => DataCell(Text(val,
                            style: const TextStyle(fontSize: 13))))
                        .toList(),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                showForm = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A67B1),
              padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Selanjutnya',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Halaman kedua: form donasi barang
  Widget _buildDonationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Formulir Donasi Barang',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF122B4B),
          ),
        ),
        const SizedBox(height: 16),

        // Input field
        _buildTextField('Nama Donatur'),
        _buildTextField('Nomor HP'),
        _buildTextField('Jumlah Barang'),
        _buildTextField('Jenis Barang / Kebutuhan'),
        _buildTextField('Tanggal Pengiriman'),
        _buildTextField('Catatan Tambahan', maxLines: 3),

        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: const Color(0xFFE6EEF8),
                  title: const Text('Terima Kasih!'),
                  content: const Text(
                    'Terima kasih atas donasi Anda! Silakan kirim barang ke alamat '
                    'panti berikut atau hubungi admin melalui WhatsApp untuk penjemputan.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup'),
                    )
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A67B1),
              padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
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
    );
  }

  // Reusable text field widget
  Widget _buildTextField(String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}