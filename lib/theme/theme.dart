import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 17, 129, 177),
secondary: const Color.fromARGB(255, 196, 87, 87),
brightness: Brightness.light,
);


final theme = ThemeData().copyWith(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android:
       CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS:
       CupertinoPageTransitionsBuilder(),
    },
  ),
  useMaterial3: true,
  textTheme: GoogleFonts.quicksandTextTheme().copyWith(
    titleLarge: GoogleFonts.quicksand().copyWith(
      fontWeight: FontWeight.bold,
    )
  ),
  colorScheme: colorScheme,
  brightness: Brightness.light,
);



