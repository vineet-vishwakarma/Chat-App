import 'package:flutter/material.dart';

// ThemeData lightmode = ThemeData.light(useMaterial3: true).copyWith();
// ThemeData darkmode = ThemeData.dark(useMaterial3: true).copyWith();

// ThemeData lightmode = ThemeData(
//   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple.shade200),
//   useMaterial3: true,
// );

// ThemeData darkmode = ThemeData(
//   colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
//   useMaterial3: true,
// );
ThemeData lightmode = ThemeData(
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade900,
  ),
);
ThemeData darkmode = ThemeData(
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade600,
    secondary: Colors.grey.shade700,
    tertiary: Colors.grey.shade800,
    inversePrimary: Colors.grey.shade300,
  ),
);
