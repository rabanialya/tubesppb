import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../auth/login_page.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';
import '../../themes/app_theme.dart';
import '../../services/auth_service.dart';
import '../../core/storage/token_storage.dart';
import '../../core/config/api_config.dart';
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
  bool _isLoggedIn = false;
  Map<String, dynamic>? _userData;

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

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await TokenStorage.isLoggedIn();
    final userData = await TokenStorage.getUser();
    
    if (mounted) {
      setState(() {
        _isLoggedIn = isLoggedIn;
        _userData = userData;
      });
    }
  }

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

  // KIRIM PESAN KE LARAVEL API
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Pesan tidak boleh kosong")));
      return;
    }

    if (!_isLoggedIn) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Login Diperlukan"),
          content: const Text("Anda harus login terlebih dahulu untuk mengirim pesan cinta."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Nanti Saja"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                ).then((_) => _checkLoginStatus());
              },
              child: const Text("Login Sekarang"),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final user = await TokenStorage.getUser();
      final token = await TokenStorage.getToken();
      
      if (user == null || token == null) {
        throw Exception('Silakan login ulang');
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/feedback'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': user['id'],
          'nama': user['nama'],
          'email': user['email'],
          'telepon': user['telepon'] ?? '',
          'pesan': _messageController.text.trim(),
          'tanggal': DateTime.now().toIso8601String().split('T')[0],
          'jam': DateTime.now().toIso8601String().split('T')[1].split('.')[0],
          'status': 'unread',
        }),
      );

      Navigator.pop(context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          _messageController.clear();
          
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text("Pesan Terkirim!"),
                ],
              ),
              content: const Text("Terima kasih atas pesan cinta Anda 💌"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup"),
                )
              ],
            ),
          );
        } else {
          throw Exception(data['message'] ?? 'Gagal mengirim pesan');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Error ${response.statusCode}');
      }

    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengirim: ${e.toString().replaceAll('Exception: ', '')}"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildUserStatusInfo() {
    if (_isLoggedIn && _userData != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Text(
          "Halo, ${_userData!['nama']}! ✨",
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Text(
          "Login untuk mengirim pesan cinta 💌",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
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
              const SizedBox(height: 10),
              
              _buildUserStatusInfo(),
              
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
                        label: Text(
                          _isLoggedIn ? "Kirim Pesan" : "Login untuk Mengirim",
                          style: const TextStyle(
                            color: Colors.white,   
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isLoggedIn 
                              ? AppColors.primaryBlue 
                              : Colors.grey,
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

              const SectionHeader(title: "Hubungi Kami", icon: Icons.phone),
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