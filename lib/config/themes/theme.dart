import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColorsLight {
  static const Color primary = Color.fromRGBO(102, 204, 138, 1);
  static const Color primaryFocus = Color.fromRGBO(65, 190, 109, 1);
  static const Color primaryContent = Color.fromRGBO(249, 250, 251, 1);

  static const Color secondary = Color.fromRGBO(55, 124, 251, 1);
  static const Color secondaryFocus = Color.fromRGBO(5, 91, 250, 1);
  static const Color secondaryContent = Color.fromRGBO(249, 250, 251, 1);

  static const Color accent = Color.fromRGBO(234, 82, 52, 1);
  static const Color accentFocus = Color.fromRGBO(208, 53, 22, 1);
  static const Color accentContent = Color.fromRGBO(249, 250, 251, 1);

  static const Color neutral = Color.fromRGBO(51, 60, 77, 1);
  static const Color neutralFocus = Color.fromRGBO(31, 36, 46, 1);
  static const Color neutralContent = Color.fromRGBO(249, 250, 251, 1);

  static const Color base100 = Color.fromRGBO(255, 255, 255, 1);
  static const Color base200 = Color.fromRGBO(249, 250, 251, 1);
  static const Color base300 = Color.fromRGBO(240, 240, 240, 1);
  static const Color baseContent = Color.fromRGBO(51, 60, 77, 1);

  static const Color info = Color.fromRGBO(28, 146, 242, 1);
  static const Color success = Color.fromRGBO(0, 148, 133, 1);
  static const Color warning = Color.fromRGBO(255, 143, 0, 1);
  static const Color error = Color.fromRGBO(255, 87, 36, 1);
}

class AppColorsDark {}

class BaseTheme {
  ThemeData get themeData {
    final theme = ThemeData(
      useMaterial3: true,

      // elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))))),

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
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(
          filled: true,
          fillColor: AppColorsLight.base300,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColorsLight.neutral, width: 2),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColorsLight.neutralFocus, width: 2),
          ),

        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: theme.elevatedButtonTheme.style?.copyWith(
          backgroundColor:
              const MaterialStatePropertyAll(AppColorsLight.primary),
          foregroundColor:
              const MaterialStatePropertyAll(AppColorsLight.baseContent),
        )),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: theme.outlinedButtonTheme.style?.copyWith(
          foregroundColor:
              const MaterialStatePropertyAll(AppColorsLight.baseContent),
        )),
        textButtonTheme: TextButtonThemeData(
            style: theme.textButtonTheme.style?.copyWith(
          foregroundColor:
              const MaterialStatePropertyAll(AppColorsLight.baseContent),
        )));
  }
}

class DarkTheme extends BaseTheme {}
