import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/top_header.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/bg_container.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _kegiatanController = PageController(viewportFraction: 0.85);
  final PageController _fasilitasController = PageController(viewportFraction: 0.85);
  final TextEditingController _messageController = TextEditingController();
  int _selectedIndex = 0;

  final List<String> kegiatanImages = [
    'assets/img/kegiatan1.jpg',
    'assets/img/kegiatan2.jpeg',
    'assets/img/kegiatan3.jpg',
    'assets/img/kegiatan4.jpg',
  ];

  final List<String> fasilitasImages = [
    'assets/img/foto1.jpg',
    'assets/img/foto2.jpg',
    'assets/img/foto3.jpg',
    'assets/img/foto4.jpg',
    'assets/img/foto5.jpg',
  ];

  void _onNavTap(int index) {
    if (index == 1) {
      _showDonationModal();
    } else if (index == 2) {
      Navigator.pushNamed(context, '/profile');
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  Future<void> _openMaps() async {
    final Uri url = Uri.parse('https://maps.app.goo.gl/b5J1N2PYyiZGKHfm9');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _showDonationModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pilih Jenis Donasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _donationOptionCard(
                      icon: Icons.inventory_2_outlined,
                      label: 'Donasi\nBarang',
                      color: AppColors.primaryBlue,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/donationgoods');
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _donationOptionCard(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Donasi\nTunai',
                      color: Colors.green.shade600,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/donationcash');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _donationOptionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesan tidak boleh kosong')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Pesan Terkirim!'),
          ],
        ),
        content: const Text(
          'Terima kasih atas pesan cinta Anda untuk Oma & Opa 💌',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _messageController.clear();
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopHeader(onNotification: () => Navigator.pushNamed(context, '/notification')),
      bottomNavigationBar: AppBottomNav(currentIndex: _selectedIndex, onTap: _onNavTap),
      body: BackgroundContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(),
                const SizedBox(height: 24),
                _buildSectionHeader('Kegiatan Panti', Icons.photo_camera),
                const SizedBox(height: 12),
                _buildImageCarousel(kegiatanImages, _kegiatanController),
                const SizedBox(height: 24),
                _buildInfoCard(
                  icon: Icons.history_edu,
                  title: 'Sejarah Panti',
                  content:
                      'Yayasan Budi Dharma Kasih berdiri sejak 1988 berawal dari visi Bapak Lie Hok Tjan untuk membangun tempat pelayanan bagi lansia. Hingga kini menjadi rumah penuh kasih dan sukacita. 🌷',
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Fasilitas Kami', Icons.apartment),
                const SizedBox(height: 12),
                _buildImageCarousel(fasilitasImages, _fasilitasController),
                const SizedBox(height: 24),
                _buildMessageSection(),
                const SizedBox(height: 24),
                _buildContactSection(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.waving_hand, color: AppColors.primaryBlue, size: 28),
              SizedBox(width: 10),
              Text(
                'Halo, Sahabat BudiKasih!',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Terima kasih sudah peduli pada kebahagiaan lansia. Mari bantu wujudkan masa tua yang penuh cinta dan ketenangan 🌼',
            style: TextStyle(color: AppColors.darkBlue, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryBlue, size: 20),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildImageCarousel(List<String> images, PageController controller) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: controller,
        itemCount: images.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(images[i], fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryBlue),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(content, style: const TextStyle(height: 1.5, color: Colors.black87, fontSize: 14)),
      ]),
    );
  }

  Widget _buildMessageSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          'Pesan Cinta untuk Oma & Opa',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkBlue),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _messageController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Tulis pesan Anda di sini...',
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _sendMessage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.send),
            label: const Text('Kirim Pesan'),
          ),
        ),
      ]),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Hubungi Kami',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkBlue)),
        const SizedBox(height: 12),
        _buildContactItem(Icons.phone, 'Telepon', '(0281) 891-829'),
        const SizedBox(height: 8),
        _buildContactItem(Icons.chat, 'WhatsApp', '+62 813-9466-1664'),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _openMaps,
          child: _buildContactItem(Icons.location_on, 'Alamat',
              'Jl. Mayjend Soengkono 510, Kalimanah, Purbalingga'),
        ),
      ]),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, color: AppColors.primaryBlue),
      const SizedBox(width: 10),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(value, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
        ]),
      ),
    ]);
  }
}