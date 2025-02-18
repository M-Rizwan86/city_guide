import 'package:flutter/material.dart';

class ChangeTheme with ChangeNotifier {
  bool _isdark = false;

  bool get isdark => _isdark;

  setTheme() {
    _isdark = !isdark;
    notifyListeners();
  }

  final lighttheme = ThemeData(
    brightness: Brightness.light,
    // Light Mode
    primaryColor: Colors.blue,
    // Customize your primary color
    hintColor: Colors.amber,
    // Customize your accent color
    scaffoldBackgroundColor: Colors.white,
    // Background color
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black), //
    ),
  );
  final darktheme = ThemeData(
    brightness: Brightness.dark,
    // Dark Mode
    primaryColor: Colors.blueGrey,
    hintColor: Colors.teal,
    scaffoldBackgroundColor: Colors.black.withRed(2),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
  );
}
