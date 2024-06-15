import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color bgColor = Color.fromRGBO(226, 226, 226, 1);
  static const Color primaryColor = Color.fromRGBO(255, 229, 1, 1);

  // static const Color primaryColor = Color.fromRGBO(170, 233, 123, 1);
  static const Color onPrimaryColor = Color.fromRGBO(20, 20, 20, 1);
  static const Color secondaryColor = Color.fromRGBO(45, 45, 45, 1);
  static const Color onSecondaryColor = Color.fromRGBO(255, 255, 255, 1);
}

class BaseTheme {
  ThemeData get themeData {
    final theme = ThemeData(
      useMaterial3: true,

      // elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))))),

      // outlined buttn
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))))),

      // text button
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))))),
    );

    return theme.copyWith(
        textTheme: GoogleFonts.nunitoSansTextTheme(theme.textTheme));
  }
}

class LightTheme extends BaseTheme {
  @override
  ThemeData get themeData {
    final theme = super.themeData;

    return theme.copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: theme.elevatedButtonTheme.style?.copyWith(
          backgroundColor:
              const MaterialStatePropertyAll(AppColors.primaryColor),
          foregroundColor:
              const MaterialStatePropertyAll(AppColors.onPrimaryColor),
        )),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: theme.outlinedButtonTheme.style?.copyWith(
          foregroundColor:
              const MaterialStatePropertyAll(AppColors.onPrimaryColor),
        )),
        textButtonTheme: TextButtonThemeData(
            style: theme.textButtonTheme.style?.copyWith(
          foregroundColor:
              const MaterialStatePropertyAll(AppColors.onPrimaryColor),
        )));
  }
}
