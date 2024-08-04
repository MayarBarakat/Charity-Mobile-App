import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


const Color kPrimaryColor = Color(0xFF87CBB9); // Primary
const Color kSecondaryColor = Color(0xFF577D86); // Secondary
const Color kBackgroundColor = Color(0xFFF5F5F5); // Background
const Color kAccentColor = Color(0xFFEFD9A8); // Accent
const Color kTextColor = Color(0xFF333333); // Text
const Color kButtonColor = Color(0xFFA7C4BC); // Button
const Color kBorderColor = Color(0xFF709293); // Border

ThemeData theme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: "Roboto",
    scaffoldBackgroundColor: kBackgroundColor,
    appBarTheme: buildAppBarTheme(),
    textTheme: buildTextTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    inputDecorationTheme: buildInputDecorationTheme(),
    colorScheme: const ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      onPrimary: kTextColor,
      onSecondary: kTextColor,
      surface: kBackgroundColor,
      onSurface: kTextColor,
      error: Colors.red,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
  );
}

TextTheme buildTextTheme() {
  return const TextTheme(
    bodyLarge: TextStyle(color: kTextColor, fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.w400),
    displayLarge: TextStyle(color: kTextColor, fontSize: 24, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(color: kTextColor, fontSize: 22, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(color: kTextColor, fontSize: 20, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: kTextColor, fontSize: 18, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(color: kTextColor, fontSize: 16, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.bold),
  );
}

AppBarTheme buildAppBarTheme() {
  return AppBarTheme(
    iconTheme: buildIconThemeData(),
    color: kPrimaryColor,
    shape: const ContinuousRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30.0),
        bottomRight: Radius.circular(30.0),
      ),
    ),
    elevation: 0,
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle.light, // Use systemOverlayStyle instead of brightness
  );
}

IconThemeData buildIconThemeData() {
  return const IconThemeData(
    color: kTextColor,
  );
}

InputDecorationTheme buildInputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: const BorderSide(color: kBorderColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
    alignLabelWithHint: true,
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}
