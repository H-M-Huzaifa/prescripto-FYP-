import 'package:flutter/material.dart';

class class_cart_provider with ChangeNotifier {

  List<Map<String, dynamic>> _cart_items = [];
  List<Map<String, dynamic>> get cart_items => _cart_items;

  double _totalprice = 0;
  double get totalprice => _totalprice;

  void totalfnc() {
    _totalprice = 0;
    for (int counter = 0; counter < cart_items.length; counter++) {
      _totalprice += _cart_items[counter]['finalprice'];
    }
    notifyListeners();
  }

  // double _totalPrice = 0; // Add total price variable
  // double get totalPrice => _totalPrice;

  void add_cart_item(Map<String, dynamic> item) {
    _cart_items.add(item);
    _totalprice += item['finalprice'];

    //_totalPrice += int.tryParse(item['price']) ?? 0; // Update total price
    notifyListeners();
  }

  void remove_cart_item(Map<String, dynamic> item) {
    _cart_items.remove(item);
    _totalprice -= item['finalprice'];
    //_totalPrice -= int.tryParse(item['price']) ?? 0; // Update total price
    notifyListeners();
  }

  void clearCart() {
    _cart_items.clear();
    _totalprice = 0;
    notifyListeners();
  }
}
