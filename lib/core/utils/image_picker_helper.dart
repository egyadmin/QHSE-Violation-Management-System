import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Image Picker Helper for Violation Form
class ViolationImagePicker {
  final ImagePicker _picker = ImagePicker();
  
  /// Take photo from camera
  Future<File?> takePhoto(BuildContext context) async {
    // Check camera permission
    final status = await Permission.camera.request();
    
    if (!status.isGranted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission required')),
        );
      }
      return null;
    }
    
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (photo != null) {
        return File(photo.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
    
    return null;
  }
  
  /// Pick image from gallery
  Future<File?> pickFromGallery(BuildContext context) async {
    // Check storage permission
    final status = await Permission.photos.request();
    
    if (!status.isGranted && !status.isLimited) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission required')),
        );
      }
      return null;
    }
    
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
    
    return null;
  }
  
  /// Show bottom sheet to choose photo source
  Future<File?> showImageSourceBottomSheet(BuildContext context, bool isArabic) async {
    return await showModalBottomSheet<File>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF0B7A3E)),
                title: Text(isArabic ? 'التقاط صورة' : 'Take Photo'),
                onTap: () async {
                  final file = await takePhoto(context);
                  if (context.mounted) {
                    Navigator.pop(context, file);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF0B7A3E)),
                title: Text(isArabic ? 'اختيار من المعرض' : 'Choose from Gallery'),
                onTap: () async {
                  final file = await pickFromGallery(context);
                  if (context.mounted) {
                    Navigator.pop(context, file);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
