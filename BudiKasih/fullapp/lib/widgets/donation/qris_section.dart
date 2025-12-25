import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';

class QrisSection extends StatelessWidget {
  final String qrisAssetPath;

  QrisSection({
    super.key,
    required this.qrisAssetPath,
  });

  Future<void> _downloadQris(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final byteData = await rootBundle.load(qrisAssetPath);

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/qris.jpg';
      final file = File(filePath);

      await file.writeAsBytes(byteData.buffer.asUint8List());

      messenger.showSnackBar(
        SnackBar(
          content: const Text("QRIS berhasil diunduh!"),
          backgroundColor: AppColors.primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text("Gagal mengunduh QRIS"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Scan QRIS",
            style: AppTextStyles.heading.copyWith(fontSize: 18, color: AppColors.darkBlue),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Image.asset(
              qrisAssetPath,
              width: 220,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _downloadQris(context),
              icon: const Icon(Icons.download, color: Colors.white,),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              label: Text("Download QRIS", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            "Scan QRIS atau unduh gambarnya. Setelah membayar, upload bukti pembayaran pada form di bawah.",
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(fontSize: 12, color: Colors.grey[600], height: 1.4),
          ),
        ],
      ),
    );
  }
}