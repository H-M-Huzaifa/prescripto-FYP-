import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class OrderHistoryProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  bool _isLoading = false;

  List<Map<String, dynamic>> _orders = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get orders => _orders;

  Future<void> fetchUserOrders() async {
    _isLoading = true;
    notifyListeners();

    String userId = _auth.currentUser?.uid ?? "";

    if (userId.isNotEmpty) {
      try {
        QuerySnapshot snapshot = await _firestore
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .get();

        _orders = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      } catch (error) {
        print("Error fetching orders: $error");
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class class_orderhistory_provider with ChangeNotifier {
//   List<Map<String, dynamic>> _orders = [];
//   List<Map<String, dynamic>> get orders => _orders;
//
//   bool _isLoading = true;
//   bool get isLoading => _isLoading;
//
//   // Fetch orders for the current user from Firestore
//   Future<void> fetchUserOrders() async {
//     User? currentUser = FirebaseAuth.instance.currentUser;
//
//     if (currentUser != null) {
//       String userId = currentUser.uid;
//
//       // Query Firestore to get the user's previous orders
//       final orderSnapshot = await FirebaseFirestore.instance
//           .collection('orders')
//           .where('userId', isEqualTo: userId)
//           .orderBy('orderDate', descending: true) // Order by date, newest first
//           .get();
//
//
//       // Map the Firestore documents into a list of orders
//       _orders = orderSnapshot.docs.map((doc) {
//         return {
//           'orderId': doc.id,
//           'name': doc['name'],
//           'address': doc['address'],
//           'contact': doc['contact'],
//           'totalPrice': doc['totalPrice'],
//           'orderDate': doc['orderDate'],
//           'cartItems': doc['cartItems'],
//           'orderNumber': doc['orderNumber'],
//         };
//       }).toList();
//
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
