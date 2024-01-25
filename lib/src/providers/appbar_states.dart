import 'package:flutter/material.dart';

class AppBarStateManager with ChangeNotifier {
  int _appBarState = 1;

  int get appBarState => _appBarState;

  void setAppBarState(int newState) {
    _appBarState = newState;
    notifyListeners();
  }
}
