import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/top_header.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/home_welcome_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/home_carousel.dart';
import '../../widgets/info_card.dart';
import '../../widgets/contact_item.dart';
import '../../widgets/donation_modal.dart'; // Import modal baru
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController kegiatanController = PageController(viewportFraction: 0.9);
  final PageController fasilitasController = PageController(viewportFraction: 0.9);
  final TextEditingController _messageController = TextEditingController();

  int currentIndex = 0;

  // Image assets
  final List<String> kegiatanImages = [
    "assets/img/kegiatan1.jpg",
    "assets/img/kegiatan2.jpeg",
    "assets/img/kegiatan3.jpg",
    "assets/img/kegiatan4.jpg"
  ];

  final List<String> fasilitasImages = [
    "assets/img/foto1.jpg",
    "assets/img/foto2.jpg",
    "assets/img/foto3.jpg",
    "assets/img/foto4.jpg",
    "assets/img/foto5.jpg",
    "assets/img/foto6.jpg",
    "assets/img/foto7.jpg",
  ];

  // Bottom Navbar Handler - UPDATED
  void _onNavTap(int index) {
    if (index == 0) {
      setState(() => currentIndex = 0);
    } else if (index == 1) {
      showDonationModal(context); // Gunakan fungsi dari donation_modal.dart
    } else if (index == 2) {
      Navigator.pushNamed(context, "/profile");
    }
    setState(() => currentIndex = index);
  }

  // Kirim pesan cinta
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Pesan tidak boleh kosong")));
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text("Pesan Terkirim!"),
          ],
        ),
        content: const Text("Terima kasih atas pesan cinta Anda 💌"),
        actions: [
          TextButton(
            onPressed: () {
              _messageController.clear();
              Navigator.pop(context);
            },
            child: const Text("Tutup"),
          )
        ],
      ),
    );
  }

  // Open maps
  Future<void> _openMaps() async {
    final url = Uri.parse("https://maps.app.goo.gl/fYAP4f7dvjddJPYB9");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopHeader(
        onNotification: () => Navigator.pushNamed(context, "/notification"),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        onTap: _onNavTap,
      ),
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeWelcomeCard(),
              const SizedBox(height: 30),

              // KEGIATAN PANTI
              const SectionHeader(title: "Kegiatan Panti", icon: Icons.event),
              const SizedBox(height: 12),
              HomeCarousel(images: kegiatanImages, controller: kegiatanController),
              const SizedBox(height: 30),

              // FASILITAS
              const SectionHeader(title: "Fasilitas Kami", icon: Icons.home_rounded),
              const SizedBox(height: 12),
              HomeCarousel(images: fasilitasImages, controller: fasilitasController),
              const SizedBox(height: 30),

              // SEJARAH
              const InfoCard(
                icon: Icons.menu_book_rounded,
                title: "Sejarah Panti",
                content:
                    "Panti Wredha BudiKasih berdiri sejak tahun 1998 sebagai tempat tinggal dan perawatan lansia yang membutuhkan dukungan dan perhatian.",
              ),
              const SizedBox(height: 30),

              // PESAN CINTA
              const SectionHeader(title: "Pesan Cinta untuk Oma & Opa", icon: Icons.favorite),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _messageController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Tulis pesan cinta Anda...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        label: const Text("Kirim Pesan"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // KONTAK
              const SectionHeader(title: "Hubungi Kami", icon: Icons.phone),
              const SizedBox(height: 16),
              ContactItem(
                icon: Icons.phone,
                label: "Telepon",
                value: "(0281) 891-829",
              ),
              const SizedBox(height: 10),
              ContactItem(
                icon: Icons.chat,
                label: "WhatsApp",
                value: "0813-9466-1664",
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: _openMaps,
                borderRadius: BorderRadius.circular(8),
                child: ContactItem(
                  icon: Icons.location_on,
                  label: "Alamat",
                  value: "Jl. Mayjend Soengkono 510, Purbalingga",
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}