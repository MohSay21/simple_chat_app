import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainColor = Colors.purple.withOpacity(0.3);

final isDarkP = StateNotifierProvider<IsDarkN, bool>(
        (ref) => IsDarkN()
);

class IsDarkN extends StateNotifier<bool> {

  IsDarkN() : super(true);

  void changeState() {
    bool newState = !state;
    state = newState;
  }

}

class MyTheme {
  static final dark = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(
      primary: mainColor,
      secondary: Colors.white,
    ),
    primaryColor: mainColor,
  );
  static final light = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.dark(
      primary: mainColor,
      secondary: Colors.grey.shade900,
    ),
    primaryColor: mainColor,
  );
}