import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // 🔹 Saat klik tombol "Donasi"
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pilihan Donasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF122B4B),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _donationButton(
                      icon: Icons.inventory_2,
                      label: 'Donasi Barang',
                      color: const Color(0xFF2A67B1),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/donationgoods');
                      },
                    ),
                    _donationButton(
                      icon: Icons.attach_money,
                      label: 'Donasi Tunai',
                      color: Colors.green.shade600,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/donationcash');
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }
    else if (index == 2) {
      // Buka halaman Profil
      Navigator.pushNamed(context, '/profile');
    }
  }

  static Widget _donationButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.black)),
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
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.church, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari sesuatu...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/notification');
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Halo, Sahabat BudiKasih! 👋',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF122B4B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Terima kasih sudah peduli pada kebahagiaan lansia. '
              'Mari bantu wujudkan masa tua yang penuh cinta dan ketenangan '
              'di Panti Wredha Budi Dharma Kasih.',
              style: TextStyle(color: Colors.black87, height: 1.4),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/kegiatan.jpg', // ganti sesuai path kamu
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '"Kasih Kristus untuk Semua" menjadi semangat kami '
              'dalam merawat dan mendampingi para lansia agar tetap hidup '
              'dengan makna, damai, dan sukacita.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            const Text(
              'Titipkan Pesan Cinta untuk Oma & Opa 💌',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF122B4B),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Pesan anda...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A67B1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Kirim Pesan'),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0xFF122B4B),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Donasi Sekarang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}