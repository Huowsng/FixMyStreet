import 'package:flutter/material.dart';

class AppBarState {
  final int state;
  AppBarState(this.state);
}

class AppBarStateManager with ChangeNotifier {
  AppBarState _appBarState = AppBarState(1);

  AppBarState get appBarState => _appBarState;

  void setAppBarState(int newState) {
    _appBarState = AppBarState(newState);
    notifyListeners();
  }
}
