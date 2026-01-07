import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Compress image
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  // Pick image from camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error taking photo: $e');
      return null;
    }
  }

  // Convert File to Base64
  static Future<String?> fileToBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      debugPrint('Error converting to base64: $e');
      return null;
    }
  }

  // Convert Base64 to File
  static Future<File?> base64ToFile(String base64String, String fileName) async {
    try {
      final bytes = base64Decode(base64String);
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      debugPrint('Error converting from base64: $e');
      return null;
    }
  }

  // Show dialog to choose image source
  static Future<File?> showImageSourceDialog(BuildContext context) async {
    return await showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Sumber Gambar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Galeri'),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await pickImageFromGallery();
                  if (context.mounted) {
                    Navigator.pop(context, file);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Kamera'),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await pickImageFromCamera();
                  if (context.mounted) {
                    Navigator.pop(context, file);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Validate image file
  static bool isValidImageFile(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png'].contains(extension);
  }

  // Get file size in MB
  static Future<double> getFileSizeInMB(File file) async {
    final bytes = await file.length();
    return bytes / (1024 * 1024);
  }

  // Check if file size is within limit
  static Future<bool> isFileSizeValid(File file, {double maxSizeMB = 5.0}) async {
    final sizeMB = await getFileSizeInMB(file);
    return sizeMB <= maxSizeMB;
  }
}