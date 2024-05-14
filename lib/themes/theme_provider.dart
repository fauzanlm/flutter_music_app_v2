import 'package:flutter/material.dart';
import 'package:flutter_music_player_app_v2/themes/dark_mode.dart';
import 'package:flutter_music_player_app_v2/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //initial data
  ThemeData _themeData = lightMode;

  //get current theme
  ThemeData get themeData => _themeData;

  //isDarkMode
  bool get isDarkMode => _themeData == darkMode;

  //set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  //toggle theme
  void toggleTheme() {
    if (isDarkMode) {
      _themeData = lightMode;
    } else {
      _themeData = darkMode;
    }
    notifyListeners();
  }
}
