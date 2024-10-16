import 'package:flutter/material.dart';

class class_fav_provider with ChangeNotifier {
  List<Map<String, dynamic>> _favourites = [];
  List<Map<String, dynamic>> get favourites => _favourites;

  void add_fav_item(Map<String,dynamic> item){
    _favourites.add(item);
    notifyListeners();
  }

  void remove_fav_item(Map<String,dynamic> item){
    _favourites.remove(item);
    notifyListeners();
  }

}