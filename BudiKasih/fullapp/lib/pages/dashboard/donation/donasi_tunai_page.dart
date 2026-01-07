import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../themes/colors.dart';
import '../../../themes/text_styles.dart';
import '../../../themes/app_theme.dart';
import '../../../widgets/reusable/top_header.dart';
import '../../../widgets/reusable/app_bottom_nav.dart';
import '../../../widgets/reusable/bg_container.dart';
import '../../../widgets/donation/transfer_bank_card.dart';
import '../../../widgets/donation/qris_section.dart';
import '../../../widgets/donation/cash_donation_form.dart';
import '../../../widgets/donation/donation_modal.dart';
import '../../../widgets/donation/donation_method_selector.dart';
import '../../../controllers/donasi_controller.dart';

class DonationCashPage extends StatefulWidget {
  const DonationCashPage({super.key});

  @override
  State<DonationCashPage> createState() => _DonationCashPageState();
}

class _DonationCashPageState extends State<DonationCashPage> {
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _hp = TextEditingController();
  final TextEditingController _nominal = TextEditingController();
  final TextEditingController _catatan = TextEditingController();

  final List<Map<String, String>> _bankAccounts = [
    {
      'bank': 'BCA',
      'number': '1234567890',
      'name': 'Yayasan Panti Wredha BDK'
    },
    {
      'bank': 'Mandiri',
      'number': '0987654321',
      'name': 'Yayasan Panti Wredha BDK'
    },
    {
      'bank': 'BNI',
      'number': '1122334455',
      'name': 'Yayasan Panti Wredha BDK'
    },
  ];

  int _selectedIndex = 1;
  String _selectedMethod = 'transfer';
  String? _buktiBase64;

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    _showSnackBar('$label berhasil disalin', Colors.green);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _submit() async {
    if (_nama.text.trim().isEmpty) {
      _showSnackBar('Nama harus diisi', Colors.orange);
      return;
    }
    if (_email.text.trim().isEmpty) {
      _showSnackBar('Email harus diisi', Colors.orange);
      return;
    }
    if (_hp.text.trim().isEmpty) {
      _showSnackBar('Nomor HP harus diisi', Colors.orange);
      return;
    }
    if (_nominal.text.trim().isEmpty) {
      _showSnackBar('Nominal donasi harus diisi', Colors.orange);
      return;
    }
    if (_buktiBase64 == null || _buktiBase64!.isEmpty) {
      _showSnackBar('Bukti transfer harus diupload', Colors.orange);
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final controller = Provider.of<DonasiController>(context, listen: false);
      
      final success = await controller.createDonationTunai(
        donatur: _nama.text.trim(),
        email: _email.text.trim(),
        hp: _hp.text.trim(),
        nominal: _nominal.text.trim(),
        metode: _selectedMethod,
        catatan: _catatan.text.trim().isEmpty ? null : _catatan.text.trim(),
        buktiBase64: _buktiBase64,
      );

      // Close loading
      if (mounted) Navigator.pop(context);

      if (success) {
        _showSuccessDialog();
      } else {
        _showSnackBar(
          controller.errorMessage ?? 'Gagal mengirim donasi',
          Colors.red,
        );
      }
    } catch (e) {
      // Close loading
      if (mounted) Navigator.pop(context);
      _showSnackBar('Error: $e', Colors.red);
    }
  }

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Terima Kasih!',
              style: AppTextStyles.heading.copyWith(
                fontSize: 22,
                color: AppColors.darkBlue,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Donasi tunai Anda telah kami terima dan sedang dalam proses verifikasi.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tim kami akan mengonfirmasi melalui WhatsApp dalam 1x24 jam.',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 12,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Kembali ke Beranda',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      showDonationModal(context);
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  Widget _buildMethodTabs() {
    return DonationMethodSelector(
      selectedMethod: _selectedMethod,
      onChange: (v) => setState(() => _selectedMethod = v),
    );
  }

  Widget _buildTransferSection() {
    return Container(
      key: const ValueKey('transfer'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance, color: AppColors.primaryBlue, size: 24),
              const SizedBox(width: 10),
              Text(
                'Rekening Tujuan',
                style: AppTextStyles.heading.copyWith(
                  fontSize: 16,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._bankAccounts.map((bank) {
            return TransferBankCard(
              bank: bank['bank']!,
              number: bank['number']!,
              name: bank['name']!,
              onCopy: () => _copyToClipboard(bank['number']!, 'Nomor rekening'),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildQrisSection() {
    return QrisSection(qrisAssetPath: 'assets/img/qris.png');
  }

  Widget _buildFormSection() {
    return CashDonationForm(
      namaController: _nama,
      emailController: _email,
      hpController: _hp,
      nominalController: _nominal,
      catatanController: _catatan,
      onSubmit: _submit,
      onBuktiChanged: (String? base64String) {
        setState(() {
          _buktiBase64 = base64String;
        });
      },
    );
  }

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _hp.dispose();
    _nominal.dispose();
    _catatan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopHeader(
        showBack: true,
        onNotification: () => Navigator.pushNamed(context, '/notification'),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
      body: BackgroundContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade600, Colors.green.shade700],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Donasi Tunai',
                              style: AppTextStyles.titleWhite.copyWith(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Setiap rupiah yang Anda berikan akan membantu kesejahteraan Oma & Opa',
                        style: AppTextStyles.titleWhite.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildMethodTabs(),
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _selectedMethod == 'transfer'
                      ? _buildTransferSection()
                      : _buildQrisSection(),
                ),
                const SizedBox(height: 24),
                _buildFormSection(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}