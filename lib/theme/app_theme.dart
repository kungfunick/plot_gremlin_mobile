import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Gothic Dark Theme Colors
  static const Color primaryDark = Color(0xFF0A0A0A);
  static const Color secondaryDark = Color(0xFF0F0F0F);
  static const Color panelDark = Color(0xFF0F0F0F);
  static const Color bloodRed = Color(0xFF660000);
  static const Color bloodLight = Color(0xFF8B0000);
  static const Color borderRed = Color(0x4D640000);
  static const Color textLight = Color(0xFFD4D4D4);
  static const Color textMid = Color(0xFFA0A0A0);
  static const Color textDim = Color(0xFF666666);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryDark,

      colorScheme: const ColorScheme.dark(
        primary: bloodRed,
        secondary: bloodLight,
        surface: panelDark,
        onPrimary: textLight,
        onSecondary: textLight,
        onSurface: textLight,
      ),

      textTheme: GoogleFonts.ebGaramondTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w300,
            letterSpacing: 8,
            color: Color(0xFF9A9A9A),
          ),
          displayMedium: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: textLight,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            letterSpacing: 3,
            color: textLight,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: textMid,
            height: 1.9,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: textMid,
          ),
          labelLarge: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 2,
            color: Color(0xFF888888),
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: bloodRed.withValues(alpha:0.8),
          foregroundColor: textLight,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          elevation: 15,
          textStyle: const TextStyle(
            fontSize: 14,
            letterSpacing: 3,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.black.withValues(alpha:0.6),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: borderRed),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: borderRed),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: bloodLight.withValues(alpha:0.6)),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF888888),
          fontSize: 12,
          letterSpacing: 2,
        ),
        hintStyle: TextStyle(
          color: textDim.withValues(alpha:0.5),
        ),
      ),

      cardTheme: CardTheme(
        color: panelDark.withValues(alpha:0.95),
        elevation: 20,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: borderRed),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: primaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.ebGaramond(
          fontSize: 24,
          fontWeight: FontWeight.w300,
          letterSpacing: 6,
          color: textLight,
        ),
      ),
    );
  }
}