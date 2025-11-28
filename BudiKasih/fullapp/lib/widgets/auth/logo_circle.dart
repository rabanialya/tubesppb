import 'package:flutter/material.dart';
import '../../themes/colors.dart';

class LogoCircle extends StatelessWidget {
  final double size;
  final String assetPath;

  const LogoCircle({
    Key? key,
    this.size = 60,
    this.assetPath = 'assets/img/logoBK.png',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}