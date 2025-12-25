import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

class NotificationDetailDialog extends StatelessWidget {
  final Map<String, dynamic> data;

  const NotificationDetailDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            data['iconColor'] as Color,
            (data['iconColor'] as Color).withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              data['icon'],
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text('Detail Laporan', style: AppTextStyles.titleWhite.copyWith(fontSize: 18))),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final String type = data['type'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(data['msg'], style: AppTextStyles.body.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.darkBlue, height: 1.5)),
        const SizedBox(height: 20),

        if (type == 'donation_received') _donationReceived(),
        if (type == 'cash_verified') _cashVerified(),
        if (type == 'message_received') _messageReceived(),
        if (type == 'urgent_need') _urgentNeed(context),

        const SizedBox(height: 20),
        _buildFooterInfo(),
      ],
    );
  }

  Widget _donationReceived() {
    return Column(
      children: [
        _buildSection('Informasi Donasi', [
          _row(Icons.person, 'Nama Donatur', data['detail']?['donorName'] ?? 'Anonymous'),
          _row(Icons.inventory_2, 'Jenis', data['detail']?['type'] ?? 'Donasi Barang'),
          _row(Icons.check_circle_outline, 'Status', 'Diterima'),
          _row(Icons.calendar_today, 'Tanggal', data['detail']?['date'] ?? '-'),
        ]),
        const SizedBox(height: 16),
        _buildSection('Detail Barang', [
          _row(Icons.shopping_bag, 'Item', data['detail']?['item'] ?? '-'),
          _row(Icons.numbers, 'Jumlah', data['detail']?['quantity'] ?? '-'),
        ]),
        const SizedBox(height: 16),
        _infoBox(
          color: Colors.green.shade700,
          text:
              'Terima kasih atas kebaikan Anda! Donasi ini sangat membantu kesejahteraan para lansia.',
        ),
      ],
    );
  }

  Widget _cashVerified() {
    return Column(
      children: [
        _buildSection('Informasi Donasi Tunai', [
          _row(Icons.account_balance_wallet, 'Nominal', data['detail']?['amount'] ?? '-'),
          _row(Icons.payment, 'Metode', data['detail']?['method'] ?? '-'),
          _row(Icons.check_circle, 'Status', 'Terverifikasi'),
          _row(Icons.calendar_today, 'Tanggal', data['detail']?['date'] ?? '-'),
        ]),
        const SizedBox(height: 16),
        _infoBox(
          color: Colors.blue.shade700,
          text:
              'Donasi tunai Anda telah dikonfirmasi dan akan digunakan untuk kebutuhan panti.',
        ),
      ],
    );
  }

  Widget _messageReceived() {
    return Column(
      children: [
        _buildSection('Pesan Terkirim', [
          _row(Icons.mail, 'Penerima', data['detail']?['recipient'] ?? '-'),
          _row(Icons.calendar_today, 'Tanggal', data['detail']?['date'] ?? '-'),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(data['detail']?['message'] ?? '-', style: AppTextStyles.body.copyWith(fontSize: 13, color: Colors.black87, height: 1.5, fontStyle: FontStyle.italic)),
        ),
      ],
    );
  }

  Widget _urgentNeed(BuildContext context) {
    return Column(
      children: [
        _buildSection('Kebutuhan Mendesak', [
          _row(Icons.priority_high, 'Prioritas', 'Tinggi'),
          _row(Icons.inventory_2, 'Item', data['detail']?['item'] ?? '-'),
          _row(Icons.numbers, 'Dibutuhkan', data['detail']?['needed'] ?? '-'),
        ]),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/donationgoods');
            },
            icon: const Icon(Icons.volunteer_activism),
            label: Text('Bantu Sekarang', style: AppTextStyles.body.copyWith(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.body.copyWith(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkBlue)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryBlue),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Text('$label: ', style: AppTextStyles.body.copyWith(fontSize: 13, color: Colors.grey[600])),
                Expanded(
                    child: Text(value, style: AppTextStyles.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox({required Color color, required String text}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: AppTextStyles.body.copyWith(fontSize: 12, color: color, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(child: Text('Untuk informasi lebih lanjut, hubungi admin melalui WhatsApp', style: AppTextStyles.body.copyWith(fontSize: 11, color: Colors.grey[600]))),
        ],
      ),
    );
  }
}