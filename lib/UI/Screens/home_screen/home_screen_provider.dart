import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../processing_screen/processing_screen.dart';

class class_homescreen_provider with ChangeNotifier{
  File? _prescriptionImage;
  bool _isProcessing = false;

  File? get prescriptionImage => _prescriptionImage;
  bool get isProcessing => _isProcessing;

  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from gallery or camera
  Future<void> pickImage(BuildContext context) async {
    final XFile? image = await _picker.pickImage(
      source: await _chooseSource(context),
    );

    if (image != null) {
      _prescriptionImage = File(image.path);
      notifyListeners();

      // After picking the image, simulate the processing
      _processImage(context);
    }
  }

  // Show a dialog to select either camera or gallery
  Future<ImageSource> _chooseSource(BuildContext context) async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Image Source"),
          actions: <Widget>[
            TextButton(
              child: Text("Camera"),
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            TextButton(
              child: Text("Gallery"),
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        );
      },
    ) ?? ImageSource.gallery; // Default to gallery if canceled
  }

  // Simulate image processing
  Future<void> _processImage(BuildContext context) async {
    _isProcessing = true;
    notifyListeners();

    // Navigate to the processing screen with the image
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProcessingScreen(imageFile: _prescriptionImage!)),
    );

    // Simulate a delay for image processing (e.g., sending to AI API)
    await Future.delayed(Duration(seconds: 3));

    _isProcessing = false;
    notifyListeners();
  }
  }