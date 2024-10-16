import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class class_user_profile_provider with ChangeNotifier{
  // User data fields
  String? _name;
  String? _email;
  String? _address;
  String? _contact;

  // TextEditingControllers for the profile screen
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  // Getters for user data
  String? get name => _name;
  String? get email => _email;
  String? get address => _address;
  String? get contact => _contact;

  // Fetch user data from Firestore and populate controllers
  Future<void> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        _name = userDoc['name'] ?? '';
        _email = userDoc['email'] ?? '';
        _address = userDoc['address'] ?? '';
        _contact = userDoc['contact'] ?? '';

        // Populate controllers
        nameController.text = _name!;
        emailController.text = _email!;
        addressController.text = _address!;
        contactController.text = _contact!;

        notifyListeners();
      }
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'name': nameController.text,
        'email': emailController.text,
        'address': addressController.text,
        'contact': contactController.text,
      });

      _name = nameController.text;
      _email = emailController.text;
      _address = addressController.text;
      _contact = contactController.text;

      notifyListeners();
    }
  }
}