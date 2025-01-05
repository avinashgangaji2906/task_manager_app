import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  fontFamily: 'Cera',
  scaffoldBackgroundColor: Colors.white,
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.all(17),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 60),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: const TextStyle(
      color: Colors.black,
    ), // Body text
    bodyMedium: TextStyle(color: Colors.grey[800]),
    bodySmall: TextStyle(color: Colors.grey[600]),
    // Secondary text
    headlineSmall: const TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold), // Headlines small
    headlineMedium: const TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold), // Headlines medium
    headlineLarge: const TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold), // Headlines large
    labelLarge: const TextStyle(color: Colors.blueAccent), // Buttons or Labels
  ),
  colorScheme: ColorScheme.fromSeed(
    primary: Colors.blueAccent,
    secondary: Colors.orange,
    tertiary: Colors.black,
    seedColor: Colors.blueAccent,
    error: Colors.redAccent,
  ),
  useMaterial3: true,
);

// ThemeData darkMode = ThemeData(
//   scaffoldBackgroundColor: Colors.black,
//   appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.black, foregroundColor: Colors.white),
//   inputDecorationTheme: InputDecorationTheme(
//     contentPadding: const EdgeInsets.all(17),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: const BorderSide(color: Colors.white60, width: 2),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: const BorderSide(color: Colors.white, width: 2),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: const BorderSide(color: Colors.white60, width: 2),
//     ),
//     errorBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: const BorderSide(color: Colors.red, width: 2),
//     ),
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.black,
//       minimumSize: const Size(double.infinity, 60),
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//     ),
//   ),
//   textTheme: TextTheme(
//     bodyLarge: const TextStyle(color: Colors.white), // Body text
//     bodyMedium: TextStyle(color: Colors.grey[400]), // Secondary text
//     headlineSmall: const TextStyle(
//         color: Colors.white, fontWeight: FontWeight.bold), // Headlines
//     headlineMedium:
//         const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//     headlineLarge:
//         const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//     labelLarge: const TextStyle(color: Colors.orange), // Buttons or Labels
//   ),
//   colorScheme: ColorScheme.fromSeed(
//     primary: Colors.blueAccent,
//     secondary: Colors.orange,
//     tertiary: Colors.black,
//     seedColor: Colors.blueAccent,
//     error: Colors.redAccent,
//   ),
// );
