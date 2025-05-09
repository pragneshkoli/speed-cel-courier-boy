import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Light theme definition
ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF4A6FE5),       // Primary blue
    secondary: const Color(0xFF2ED9A0),     // Success green
    tertiary: const Color(0xFFFF9D54),      // Warning/notification orange
    error: const Color(0xFFE53935),         // Error red
    surface: const Color(0xFFF9FAFC),       // Light background
    background: const Color(0xFFFFFFFF),    // White background
    onPrimary: const Color(0xFFFFFFFF),     // White text on primary
    onSecondary: const Color(0xFF0A0E21),   // Dark text on secondary
    onTertiary: const Color(0xFF0A0E21),    // Dark text on tertiary
    onSurface: const Color(0xFF0A0E21),     // Dark text on surface
    onBackground: const Color(0xFF0A0E21),  // Dark text on background
    onError: const Color(0xFFFFFFFF),       // White text on error
    outline: const Color(0xFFDCE0E9),       // Light border color
  ),
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Color(0xFFFFFFFF),
    scrolledUnderElevation: 1.0,
  ),
  cardTheme: CardTheme(
    elevation: 0,
    color: const Color(0xFFFFFFFF),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF9FAFC),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFDCE0E9), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFDCE0E9), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF4A6FE5), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE53935), width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
    ),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 57.0,
      fontWeight: FontWeight.normal,
      color: const Color(0xFF0A0E21),
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 45.0,
      fontWeight: FontWeight.normal,
      color: const Color(0xFF0A0E21),
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 36.0,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF0A0E21),
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 32.0,
      fontWeight: FontWeight.normal,
      color: const Color(0xFF0A0E21),
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 24.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF0A0E21),
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF0A0E21),
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 22.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF0A0E21),
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF0A0E21),
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF0A0E21),
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF0A0E21),
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF0A0E21),
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF0A0E21),
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: const Color(0xFF0A0E21),
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: const Color(0xFF0A0E21),
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: const Color(0xFF0A0E21),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF4A6FE5);
        }
        return null;
      },
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFFF1F2F6),
    disabledColor: const Color(0xFFDCE0E9),
    selectedColor: const Color(0xFF4A6FE5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    labelStyle: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF0A0E21),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Color(0xFFDCE0E9),
    thickness: 1,
    space: 1,
  ),
);

// Dark theme definition
ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFF4A6FE5),       // Primary blue
    secondary: const Color(0xFF2ED9A0),     // Success green
    tertiary: const Color(0xFFFF9D54),      // Warning/notification orange
    error: const Color(0xFFE53935),         // Error red
    surface: const Color(0xFF1A1C2E),       // Dark elevated surface
    background: const Color(0xFF0F1122),    // Dark background
    onPrimary: const Color(0xFFFFFFFF),     // White text on primary
    onSecondary: const Color(0xFF0A0E21),   // Dark text on secondary
    onTertiary: const Color(0xFF0A0E21),    // Dark text on tertiary
    onSurface: const Color(0xFFF9FAFC),     // Light text on surface
    onBackground: const Color(0xFFF9FAFC),  // Light text on background
    onError: const Color(0xFFFFFFFF),       // White text on error
    outline: const Color(0xFF2D3142),       // Dark border color
  ),
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Color(0xFF0F1122),
    scrolledUnderElevation: 1.0,
  ),
  cardTheme: CardTheme(
    elevation: 0,
    color: const Color(0xFF1A1C2E),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1A1C2E),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2D3142), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2D3142), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF4A6FE5), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE53935), width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
    ),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 57.0,
      fontWeight: FontWeight.normal,
      color: const Color(0xFFF9FAFC),
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 45.0,
      fontWeight: FontWeight.normal,
      color: const Color(0xFFF9FAFC),
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 36.0,
      fontWeight: FontWeight.w600,
      color: const Color(0xFFF9FAFC),
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 32.0,
      fontWeight: FontWeight.normal,
      color: const Color(0xFFF9FAFC),
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 24.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFFF9FAFC),
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFF9FAFC),
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 22.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFFF9FAFC),
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFFF9FAFC),
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFFF9FAFC),
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFFF9FAFC),
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFFF9FAFC),
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFFF9FAFC),
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: const Color(0xFFF9FAFC),
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: const Color(0xFFF9FAFC),
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: const Color(0xFFF9FAFC),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF4A6FE5);
        }
        return null;
      },
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFF2D3142),
    disabledColor: const Color(0xFF1F2235),
    selectedColor: const Color(0xFF4A6FE5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    labelStyle: GoogleFonts.inter(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFFF9FAFC),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Color(0xFF2D3142),
    thickness: 1,
    space: 1,
  ),
);