import 'package:chat_app/utils/theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightmode;
  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkmode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData == lightmode ? themeData = darkmode : themeData = lightmode;
  }
}
