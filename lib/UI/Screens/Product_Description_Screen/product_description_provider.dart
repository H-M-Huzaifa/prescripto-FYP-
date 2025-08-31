import 'package:flutter/material.dart';

class class_prod_desc extends ChangeNotifier {
  int _quantity = 1;

  int get quantity => _quantity;

  void quantity_increment() {
    _quantity++;
    notifyListeners();
  }

  void quantity_decrement() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void reset_quantity() {
    _quantity = 1;
    notifyListeners();
  }

  // Add this method to set a specific quantity value
  void set_quantity(int newQuantity) {
    if (newQuantity > 0) {
      _quantity = newQuantity;
      notifyListeners();
    }
  }
}