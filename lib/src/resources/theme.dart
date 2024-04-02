import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/resources/colors.dart';

class CustomTheme with ChangeNotifier {
  static ThemeData get lightTheme {
    return ThemeData(
        useMaterial3: true,
        textTheme: const TextTheme(labelMedium: TextStyle(fontSize: 16)),
        primaryColor: CustomColors.bottomActiveIconColor,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
            seedColor: CustomColors.bottomActiveIconColor,
            brightness: Brightness.light),
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: CustomColors.whiteColor,
        ));
  }

  static ThemeData get darkTheme {
    return ThemeData(
        useMaterial3: true,
        primaryColor: CustomColors.bottomActiveIconColor,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
            labelMedium: TextStyle(fontSize: 16),
            bodySmall: TextStyle(color: Colors.black)),
        colorScheme: ColorScheme.fromSeed(
            seedColor: CustomColors.bottomActiveIconColor,
            brightness: Brightness.dark),
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: CustomColors.greyColor,
        ));
  }
}
