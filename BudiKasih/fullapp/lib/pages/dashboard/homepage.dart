import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../themes/colors.dart';
import '../../themes/text_styles.dart';
import '../../themes/app_theme.dart';

import '../../widgets/reusable/top_header.dart';
import '../../widgets/reusable/app_bottom_nav.dart';
import '../../widgets/homepage/home_welcome_card.dart';
import '../../widgets/homepage/section_header.dart';
import '../../widgets/homepage/home_carousel.dart';
import '../../widgets/homepage/info_card.dart';
import '../../widgets/homepage/contact_item.dart';
import '../../widgets/donation/donation_modal.dart';


void _openURL(String url) async {
  final uri = Uri.parse(url);

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    debugPrint("Gagal membuka link: $url");
  }
}

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

  void _onNavTap(int index) {
    if (index == 0) {
      setState(() => currentIndex = 0);
    } else if (index == 1) {
      showDonationModal(context); 
    } else if (index == 2) {
      Navigator.pushNamed(context, "/profile");
    }
    setState(() => currentIndex = index);
  }

  // Kirim pesan
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

              const SectionHeader(title: "Kegiatan Panti", icon: Icons.event),
              const SizedBox(height: 12),
              HomeCarousel(images: kegiatanImages, controller: kegiatanController),
              const SizedBox(height: 30),

              const SectionHeader(title: "Fasilitas Kami", icon: Icons.home_rounded),
              const SizedBox(height: 12),
              HomeCarousel(images: fasilitasImages, controller: fasilitasController),
              const SizedBox(height: 30),

              const InfoCard(
                icon: Icons.menu_book_rounded,
                title: "Sejarah Panti",
                content:
                    "Sejarah yayasan ini dimulai pada tahun 1972 ketika Bapak Lie Hok Tjan (Budi Soedarma) memiliki visi mulia untuk mendirikan sebuah Panti Wredha. Beliau tidak hanya mencetuskan ide ini, tetapi juga menunjukkan keseriusannya dengan bersedia menghibahkan sebagian tanah miliknya yang berlokasi di Kalimanah, Purbalingga. Tanah ini dipersiapkan secara khusus untuk mewujudkan impiannya tersebut.",
              ),
              const SizedBox(height: 30),

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
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,    
                        ),
                        label: const Text(
                          "Kirim Pesan",
                          style: TextStyle(
                            color: Colors.white,   
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white, 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              SectionHeader(title: "Hubungi Kami", icon: Icons.phone),
              const SizedBox(height: 20),

              ContactItem(
                icon: Icons.chat,
                label: "WhatsApp",
                value: "0813-9466-1664",
                onTap: () => _openURL("https://wa.me/6281394661664"),
              ),

              const SizedBox(height: 12),

              ContactItem(
                icon: Icons.camera_alt_outlined,
                label: "Instagram",
                value: "@pantiwredhabudidharmakasih",
                onTap: () => _openURL("https://www.instagram.com/pantiwredabudidharmakasih?igsh=MWdidXVnMXl5c3F5Nw=="),
              ),

              const SizedBox(height: 12),

              ContactItem(
                icon: Icons.play_circle_fill,
                label: "YouTube",
                value: "pantiwredhabudidharmakasih8513",
                onTap: () => _openURL("https://youtube.com/@pantiwredhabudidharmakasih8513"),
              ),

              const SizedBox(height: 12),

              ContactItem(
                icon: Icons.location_on,
                label: "Alamat",
                value: "Jl. Raya Mayjen Soengkono No.510, Kalimanah, Purbalingga",
                onTap: _openMaps,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}