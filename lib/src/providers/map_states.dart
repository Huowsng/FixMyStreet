import 'package:flutter/material.dart';

class MapState with ChangeNotifier {
  bool _showHelpScreen = false;
  bool _showIcon = false;
  bool _showPinIcon = false;
  bool _showTextButton = true;
  bool _showReportScreen = false;
  bool _showLogin = false;
  bool _showRegister = false;
  bool _showPinDetail = false;
  bool _showDraft = false;
  bool get showDraft => _showDraft;
  bool get showPinDetail => _showPinDetail;
  bool get showLogin => _showLogin;
  bool get showIcon => _showIcon;
  bool get showHelpScreen => _showHelpScreen;
  bool get showPinIcon => _showPinIcon;
  bool get showTextButoon => _showTextButton;
  bool get showReportScreen => _showReportScreen;
  bool get showRegister => _showRegister;
  
  void setShowHelpScreen(bool value) {
    _showHelpScreen = value;
    notifyListeners();
  }

  void setShowIcon(bool value) {
    _showIcon = value;
    notifyListeners();
  }

  void setShowPinIcon(bool value) {
    _showPinIcon = value;
    notifyListeners();
  }

  void setShowTextButton(bool value) {
    _showTextButton = value;
    notifyListeners();
  }

  void setShowReportScreen(bool value) {
    _showReportScreen = value;
    notifyListeners();
  }

  void setShowLogin(bool value) {
    _showLogin = value;
    notifyListeners();
  }

  void setShowRegister(bool value) {
    _showRegister = value;
    notifyListeners();
  }

  void setShowPinDetail(bool value) {
    _showPinDetail = value;
    notifyListeners();
  }

  void setShowDraft(bool value) {
    _showDraft = value;
    notifyListeners();
  }
}
