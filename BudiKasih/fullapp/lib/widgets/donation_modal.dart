import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../themes/text_styles.dart';

// Function helper untuk menampilkan modal donasi secara konsisten
void showDonationModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true, // Tambahkan ini untuk kontrol scroll
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              // Title
              Text('Pilih Jenis Donasi', style: AppTextStyles.heading.copyWith(fontSize: 20, color: AppColors.darkBlue)),
              const SizedBox(height: 8),
              // Subtitle
              Text('Setiap bantuan Anda sangat berarti', style: AppTextStyles.body.copyWith(fontSize: 13, color: Colors.grey[600])),
              const SizedBox(height: 24),
              // Donation options
              Row(
                children: [
                  Expanded(
                    child: DonationOptionCard(
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
                    child: DonationOptionCard(
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}

// Widget untuk card option donasi
class DonationOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const DonationOptionCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 12),
            Text(label, textAlign: TextAlign.center, style: AppTextStyles.body.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: color, height: 1.3)),
          ],
        ),
      ),
    );
  }
}