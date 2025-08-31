import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class class_fav_provider with ChangeNotifier {
  List<Map<String, dynamic>> _favourites = [];
  List<Map<String, dynamic>> get favourites => _favourites;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isInitialized = false;

  // Initialize the provider with user ID
  Future<void> initialize(String userId) async {
    if (!_isInitialized) {
      await fetchUserFavorites(userId);
      _isInitialized = true;
    }
  }

  // Fetch user favorites from Firestore
  Future<void> fetchUserFavorites(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('userFavorites').doc(userId).get();

      if (userDoc.exists && userDoc.data() != null) {
        _favourites = List<Map<String, dynamic>>.from(userDoc['favorites']);
      } else {
        _favourites = [];
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching user favorites: $e');
    }
  }

  // Add favorite item to Firestore
  Future<void> add_fav_item(String userId, Map<String, dynamic> item) async {
    if (!_favourites.any((fav) => fav['name'] == item['name'])) {
      _favourites.add(item);
      await _updateUserFavoritesInFirestore(userId);
      notifyListeners();
    }
  }

  // Remove favorite item from Firestore
  Future<void> remove_fav_item(String userId, Map<String, dynamic> item) async {
    _favourites.removeWhere((fav) => fav['name'] == item['name']);
    await _updateUserFavoritesInFirestore(userId);
    notifyListeners();
  }

  // Private method to update the Firestore document for the user's favorites
  Future<void> _updateUserFavoritesInFirestore(String userId) async {
    try {
      await _firestore.collection('userFavorites').doc(userId).set({
        'favorites': _favourites,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating user favorites in Firestore: $e');
    }
  }
}
