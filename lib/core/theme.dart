import 'package:flutter/material.dart';

/// Colors carried over from the web app's CSS variables.
class AppColors {
  const AppColors._();

  static const bg = Color(0xFF080C17);
  static const bgDeep = Color(0xFF0D1A3A);
  static const bgEnd = Color(0xFF07101F);
  static const surface = Color(0xFF0E1428);
  static const card = Color(0x0AFFFFFF); // 4% white
  static const cardRaised = Color(0x12FFFFFF); // 7% white
  static const border = Color(0x14FFFFFF); // 8% white

  /// Money. The fares that answer the rider's question are amber.
  static const amber = Color(0xFFFBBC24);
  static const amberSoft = Color(0x26FBBC24); // 15%
  static const amberFaint = Color(0x14FBBC24); // 8%
  static const amberLine = Color(0x4DFBBC24); // 30%
  static const onAmber = Color(0xFF1C1404);
  static const orange = Color(0xFFF97316);

  /// Boarding stop.
  static const green = Color(0xFF22D3A5);

  /// Destination stop and errors.
  static const red = Color(0xFFF87171);
  static const redSoft = Color(0x1AF87171);

  static const text = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF94A3B8);
  static const textMuted = Color(0xFF64748B);
}

class AppText {
  const AppText._();

  static const family = 'HindSiliguri';

  static const caption = TextStyle(
      fontSize: 12, height: 1.4, color: AppColors.textMuted);
  static const label = TextStyle(
      fontSize: 13, height: 1.4, color: AppColors.textSecondary);
  static const body = TextStyle(
      fontSize: 15, height: 1.5, color: AppColors.text);
  static const bodyStrong = TextStyle(
      fontSize: 16, height: 1.4, fontWeight: FontWeight.w600, color: AppColors.text);
  static const title = TextStyle(
      fontSize: 20, height: 1.3, fontWeight: FontWeight.w700, color: AppColors.text);
  static const display = TextStyle(
      fontSize: 26, height: 1.2, fontWeight: FontWeight.w700, color: AppColors.text);

  /// The fare figure.
  static const fare = TextStyle(
      fontSize: 34, height: 1.0, fontWeight: FontWeight.w700, color: AppColors.amber);
  static const fareHero = TextStyle(
      fontSize: 48, height: 1.0, fontWeight: FontWeight.w700, color: AppColors.amber);
}

ThemeData buildAppTheme() {
  const scheme = ColorScheme.dark(
    primary: AppColors.amber,
    onPrimary: AppColors.onAmber,
    secondary: AppColors.green,
    onSecondary: AppColors.bg,
    surface: AppColors.bg,
    onSurface: AppColors.text,
    surfaceTint: Colors.transparent,
    error: AppColors.red,
    onError: AppColors.bg,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    fontFamily: AppText.family,
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      space: 1,
      thickness: 1,
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: AppColors.amber),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}

/// Shared input style (feedback form).
InputDecoration appInputDecoration(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textMuted),
      filled: true,
      fillColor: AppColors.card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.amber, width: 1.5),
      ),
    );
