import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../themes/colors.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const StepProgressIndicator({
    Key? key,
    required this.currentStep,
    this.labels = const ['Email', 'Kode', 'Password'],
  }) : super(key: key);

  Widget _buildStepCircle(int stepNumber, String label) {
    final isActive = currentStep >= stepNumber;
    final isCurrent = currentStep == stepNumber;

    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrent ? Colors.white : Colors.transparent,
              width: 3,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isActive && currentStep > stepNumber
                ? const Icon(Icons.check, color: AppColors.primaryBlue, size: 24)
                : Text(
                    '$stepNumber',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isActive ? AppColors.primaryBlue : Colors.white,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 24),
      color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(1, labels[0]),
        _buildStepLine(currentStep > 1),
        _buildStepCircle(2, labels[1]),
        _buildStepLine(currentStep > 2),
        _buildStepCircle(3, labels[2]),
      ],
    );
  }
}