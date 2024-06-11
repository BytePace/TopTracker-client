import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/resources/colors.dart';

class CustomTheme with ChangeNotifier {
  static ThemeData get lightTheme {
    return ThemeData(
        useMaterial3: true,
        textTheme: const TextTheme(labelMedium: TextStyle(fontSize: 16)),
        primaryColor: CustomColors.whiteColor,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
            seedColor: CustomColors.blackColor, brightness: Brightness.light),
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: CustomColors.whiteColor,
        ));
  }

  static ThemeData get darkTheme {
    return ThemeData(
        useMaterial3: true,
        dialogTheme: const DialogTheme(backgroundColor: Colors.black),
        tooltipTheme: const TooltipThemeData(
          decoration: BoxDecoration(color: Colors.black),
        ),
        scaffoldBackgroundColor: Colors.black,
        popupMenuTheme: const PopupMenuThemeData(
          color: Colors.black,
        ),
        primaryColor: CustomColors.blackColor,
        textTheme: const TextTheme(
            labelMedium: TextStyle(fontSize: 16, color: Colors.white),
            bodySmall: TextStyle(color: Colors.white)),
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark, seedColor: Colors.black),
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: CustomColors.blackColor,
        ));
  }
}
