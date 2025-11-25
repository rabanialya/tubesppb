import 'package:flutter/material.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileHeader extends StatefulWidget {
  final String name;
  final String email;
  final Function(String path) onImageSelected;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.onImageSelected,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String? imagePath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() => imagePath = file.path);
      widget.onImageSelected(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryBlue.withOpacity(0.85)
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      imagePath != null ? Image.file(File(imagePath!)).image : null,
                  child: imagePath == null
                      ? const Icon(Icons.person,
                          color: AppColors.primaryBlue, size: 56)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt,
                        size: 20, color: AppColors.primaryBlue),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(widget.name, style: AppTextStyles.titleWhite.copyWith(fontSize: 24)),
          const SizedBox(height: 6),
          Text(widget.email, style: AppTextStyles.titleWhite.copyWith(fontSize: 14, color: Colors.white.withOpacity(0.9))),
        ],
      ),
    );
  }
}