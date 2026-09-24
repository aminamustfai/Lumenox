import 'package:flutter/material.dart';

/// Colors picked to match the Lumenox screens you shared.
class AppColors {
  static const Color primaryGreen = Color(0xFF3F9166);
  static const Color darkGreen = Color(0xFF2E7A54);
  static const Color splashGreen = Color(0xFF4F9E77);
  static const Color mintLight = Color(0xFFE3F1E6);
  static const Color mintDark = Color(0xFFBFDCC7);
  static const Color textDark = Color(0xFF14241B);
  static const Color textGrey = Color(0xFF6B7A72);
  static const Color danger = Color(0xFFE05B4C);
  static const Color inputFill = Colors.white;
}

class AppGradients {
  static const LinearGradient authBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.mintLight, AppColors.mintDark],
  );

  static const LinearGradient splashBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.splashGreen, AppColors.primaryGreen],
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryGreen),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.4),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(58),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
