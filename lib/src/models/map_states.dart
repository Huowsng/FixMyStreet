import 'package:flutter/material.dart';

class MapState with ChangeNotifier {
  bool _showHelpScreen = false;

  bool get showHelpScreen => _showHelpScreen;

  void setShowHelpScreen(bool value) {
    _showHelpScreen = value;
    notifyListeners();
  }
}