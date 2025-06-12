import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../processing_screen/processing_screen.dart';

class class_homescreen_provider with ChangeNotifier {
  File? _prescriptionImage;
  bool _isProcessing = false;

  File? get prescriptionImage => _prescriptionImage;
  bool get isProcessing => _isProcessing;

  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from gallery or camera
  Future<void> pickImage(BuildContext context) async {
    try {
      final ImageSource? source = await _chooseSource(context);

      if (source == null) return; // User cancelled source selection

      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85, // Reduce quality to avoid large file sizes
        maxWidth: 1024,   // Limit image size
        maxHeight: 1024,
      );

      if (image != null) {
        _prescriptionImage = File(image.path);
        notifyListeners();

        // Navigate to processing screen
        _processImage(context);
      }
    } catch (e) {
      print('Error picking image: $e');
      _showErrorDialog(context, 'Error selecting image: $e');
    }
  }

  // Show a dialog to select either camera or gallery
  Future<ImageSource?> _chooseSource(BuildContext context) async {
    return await showDialog<ImageSource>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Image Source"),
          content: Text("Choose how you want to select your prescription image:"),
          actions: <Widget>[
            TextButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(width: 8),
                  Text("Camera"),
                ],
              ),
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            TextButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_library),
                  SizedBox(width: 8),
                  Text("Gallery"),
                ],
              ),
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // Navigate to processing screen
  void _processImage(BuildContext context) {
    if (_prescriptionImage != null) {
      _isProcessing = true;
      notifyListeners();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProcessingScreen(imageFile: _prescriptionImage!),
        ),
      ).then((_) {
        // Reset processing state when returning from processing screen
        _isProcessing = false;
        notifyListeners();
      });
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Clear the selected image
  void clearImage() {
    _prescriptionImage = null;
    _isProcessing = false;
    notifyListeners();
  }
}