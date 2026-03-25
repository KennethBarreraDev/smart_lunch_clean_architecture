import 'package:flutter/material.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';


const Color greyNavBarIcon = Color(0xFFC2C4CE);

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Comfortaa',


    scaffoldBackgroundColor: AppColors.white,

    colorScheme:  ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.orange,
      onPrimary: AppColors.white,
      secondary: AppColors.coral,
      onSecondary: Colors.white,
      error: AppColors.lightRed,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: AppColors.darkBlue,
    ),

    appBarTheme:  AppBarTheme(
      backgroundColor: AppColors.orange,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),

    bottomNavigationBarTheme:  BottomNavigationBarThemeData(
      selectedItemColor: AppColors.orange,
      unselectedItemColor: greyNavBarIcon,
    ),

    textTheme:  TextTheme(
      headlineLarge: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: AppColors.darkBlue),
    ),
  );
}