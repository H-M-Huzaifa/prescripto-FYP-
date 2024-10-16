import 'package:flutter/cupertino.dart';

class class_prod_desc with ChangeNotifier{

  int _quantity = 1; // Add a quantity field
  int get quantity => _quantity; // Add a quantity field

  void quantity_decrement(){
    if(_quantity>1){
      _quantity--;
      notifyListeners();
    }
  }

  void quantity_increment(){
    _quantity++;
    notifyListeners();
  }

  void reset_quantity(){
    _quantity=1;
    notifyListeners();
  }
}