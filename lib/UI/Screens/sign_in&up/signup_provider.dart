import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class class_sign_up_provider with ChangeNotifier {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  // For storing and displaying the image
  String? _imageUrl;
  XFile? _pickedImage; // Locally picked image before upload

  String? get imageUrl => _imageUrl;
  XFile? get pickedImage => _pickedImage;

  // Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  // Method to clear the image data and reset other necessary fields
  void clearImageData() {
    _imageUrl = null;
    _pickedImage = null;
    notifyListeners(); // Notify to update UI accordingly
  }

  // Fetch the image from Firestore for a logged-in user
  Future<void> fetchUserImage() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists && userDoc['image'] != null) {
          _imageUrl = userDoc['image'];
          notifyListeners(); // Update UI with the fetched image
        }
      }
    } catch (e) {
      print('Error fetching user image: $e');
    }
  }

  // Pick an image for preview (before sign-up)
  Future<void> pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      _pickedImage = file;
      notifyListeners();  // Update UI with the picked image
    }
  }

  // Upload image to Firebase Storage after the user has signed up and update Firestore
  Future<void> uploadImageAndSaveToFirestore() async {
    if (_pickedImage == null) return;

    String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('users_images');
    Reference imageToUpload = referenceDirImages.child(uniqueFilename);

    try {
      // Upload file to Firebase Storage
      await imageToUpload.putFile(File(_pickedImage!.path));
      String downloadURL = await imageToUpload.getDownloadURL();

      // Update Firestore with the new image URL
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set({'image': downloadURL}, SetOptions(merge: true));
      }

      // Update local image URL and notify listeners
      _imageUrl = downloadURL;
      notifyListeners();
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
