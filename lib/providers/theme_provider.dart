import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const themeStatus = "THEME_STATUS";
  bool _darkTheme = false; // private
  bool get getIsDarkTheme => _darkTheme;

  ThemeProvider() {
    getTheme();
  }

  Future<void> setDarkTheme({required bool themevalue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // key (themeStatus) should be the same while getting it back from shared preferences
    prefs.setBool(themeStatus, themevalue);
    _darkTheme = themevalue;
    notifyListeners();
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _darkTheme = prefs.getBool(themeStatus) ?? false;
    notifyListeners();
    return _darkTheme;
  }
}
