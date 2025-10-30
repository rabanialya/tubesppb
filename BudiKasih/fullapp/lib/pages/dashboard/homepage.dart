import 'package:flutter/material.dart';
import '../../widgets/top_header.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../themes/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onNavTap(int idx) {
    if (idx == 1) {
      // tampilkan pilihan donasi
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('Pilihan Donasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF122B4B))),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/donationgoods');
                  },
                  child: Column(children: [
                    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.inventory_2, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('Donasi Barang'),
                  ]),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/donationcash');
                  },
                  child: Column(children: [
                    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.attach_money, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('Donasi Tunai'),
                  ]),
                ),
              ]),
            ]),
          );
        },
      );
      return;
    }
    if (idx == 2) {
      Navigator.pushNamed(context, '/profile');
      return;
    }
    setState(() => _selectedIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopHeader(onNotification: () => Navigator.pushNamed(context, '/notification')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Halo, Sahabat BudiKasih!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF122B4B))),
          const SizedBox(height: 8),
          const Text('Terima kasih sudah peduli... (deskripsi singkat panti)', style: TextStyle(color: Colors.black87, height: 1.4)),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/images/kegiatan.jpg', fit: BoxFit.cover)), // pastikan asset ada
          const SizedBox(height: 12),
          const Text('"Kasih Kristus untuk Semua"...', style: TextStyle(fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 12),
          const Text('Titipkan Pesan Cinta untuk Oma & Opa', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF122B4B))),
          const SizedBox(height: 8),
          TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Pesan anda...', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () {}, child: const Text('Kirim Pesan')),
        ]),
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: _selectedIndex, onTap: _onNavTap),
    );
  }
}