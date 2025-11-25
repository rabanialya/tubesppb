import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../widgets/top_header.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../../widgets/bg_container.dart';
import '../../../themes/colors.dart';
import '../../../themes/text_styles.dart';
import '../../../widgets/transfer_bank_card.dart';
import '../../../widgets/qris_section.dart';
import '../../../widgets/cash_donation_form.dart';
import '../../../widgets/donation_modal.dart';
import '../../../widgets/donation_method_selector.dart';

class DonationCashPage extends StatefulWidget {
  const DonationCashPage({super.key});

  @override
  State<DonationCashPage> createState() => _DonationCashPageState();
}

class _DonationCashPageState extends State<DonationCashPage> {
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _hp = TextEditingController();
  final TextEditingController _nominal = TextEditingController();
  final TextEditingController _tanggal = TextEditingController();
  final TextEditingController _catatan = TextEditingController();
  
  File? _buktiTransferFromForm;

  final List<Map<String, String>> _bankAccounts = [
    {'bank': 'BCA', 'number': '1234567890', 'name': 'Yayasan Panti Wredha BDK'},
    {'bank': 'Mandiri', 'number': '0987654321', 'name': 'Yayasan Panti Wredha BDK'},
    {'bank': 'BNI', 'number': '1122334455', 'name': 'Yayasan Panti Wredha BDK'},
  ];

  int _selectedIndex = 1;
  String _selectedMethod = 'transfer';

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

  Future<void> _pickDate() async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2035),
  );

  if (picked != null) {
    setState(() {
      _tanggal.text = "${picked.day}-${picked.month}-${picked.year}";
    });
  }
}


  Future<void> _submit() async {
    if (_nama.text.trim().isEmpty) {
      _showSnackBar('Nama harus diisi', Colors.orange);
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

    final confirmNoBukti = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda sudah upload bukti transfer? Jika belum, anda masih bisa mengirim tanpa bukti.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Belum')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sudah')),
        ],
      ),
    );

    if (confirmNoBukti == null || confirmNoBukti == false) {
      _showSnackBar('Mohon upload bukti transfer atau konfirmasi', Colors.orange);
      return;
    }

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
              style: AppTextStyles.heading.copyWith(fontSize: 22, color: AppColors.darkBlue),
            ),
            const SizedBox(height: 12),
            Text(
              'Donasi tunai Anda telah kami terima dan sedang dalam proses verifikasi.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(fontSize: 14, color: Colors.grey[700], height: 1.5),
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
                      style: AppTextStyles.body.copyWith(fontSize: 12, color: Colors.grey[700], height: 1.4),
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
                child: Text('Kembali ke Beranda', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
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
      showDonationModal(context); // ✅ Gunakan fungsi dari donation_modal.dart
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
              Text('Rekening Tujuan', style: AppTextStyles.heading.copyWith(fontSize: 16, color: AppColors.darkBlue)),
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
  return QrisSection(qrisAssetPath: 'assets/img/qris.jpg');
  }

  Widget _buildFormSection() {
    return CashDonationForm(
      namaController: _nama,
      hpController: _hp,
      nominalController: _nominal,
      tanggalController: _tanggal,
      catatanController: _catatan,
      onPickDate: _pickDate,
      onSubmit: _submit,
    );
  }

  @override
  void dispose() {
    _nama.dispose();
    _hp.dispose();
    _nominal.dispose();
    _tanggal.dispose();
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
      bottomNavigationBar: AppBottomNav(currentIndex: _selectedIndex, onTap: _onNavTap),
      body: BackgroundContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
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
                  child: _selectedMethod == 'transfer' ? _buildTransferSection() : _buildQrisSection(),
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