import 'package:flutter/material.dart';

class MapState with ChangeNotifier {
  bool _showHelpScreen = false;
  bool _showIcon = false;
  bool get showIcon => _showIcon;
  bool get showHelpScreen => _showHelpScreen;
  void setShowHelpScreen(bool value) {
    _showHelpScreen = value;
    notifyListeners();
  }

  void setShowIcon(bool value) {
    _showIcon = value;
    notifyListeners();
  }
}
