import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class class_checkout_provider with ChangeNotifier {

  // TextEditingControllers for the checkout screen
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  // Fetch delivery information from the user profile (if available)
  Future<void> fetchDeliveryInfo({
    required String name,
    required String address,
    required String contact,
  }) async {
    // Set the controllers with the data
    nameController.text = name;
    addressController.text = address;
    contactController.text = contact;
  }

  Future<void> placeOrder({
    required List<Map<String, dynamic>> cartItems,
    required double totalPrice,
  }) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;
      String userName = nameController.text;

      // Get the number of previous orders
      QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      // Determine the next order number (previous count + 1)
      int orderNumber = orderSnapshot.docs.length + 1;
      String orderId = "$userName-$orderNumber";

      // Prepare the order data
      Map<String, dynamic> orderData = {
        'userId': userId,
        'name': userName,
        'address': addressController.text,
        'contact': contactController.text,
        'cartItems': cartItems,
        'totalPrice': totalPrice,
        'orderDate': FieldValue.serverTimestamp(),
        'orderNumber': orderNumber, // Store order number
      };

      // Save to Firestore in the "orders" collection with custom document ID
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId) // Custom document ID
          .set(orderData);
    }
  }




  // Dispose the controllers
  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    contactController.dispose();
    super.dispose();
  }
}
