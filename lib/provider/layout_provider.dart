import 'package:flutter/material.dart';

class LayoutProvider extends ChangeNotifier {
  int layout = 1;

  setLayout(int src) {
    layout = src;
    notifyListeners();
  }
}
