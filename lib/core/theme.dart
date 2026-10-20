import 'package:flutter/material.dart';

/// Colors for one brightness. Dark is carried over from the web app's CSS
/// variables; light keeps the same roles with contrast tuned for a white page.
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.bgDeep,
    required this.bgEnd,
    required this.surface,
    required this.card,
    required this.border,
    required this.rail,
    required this.amber,
    required this.amberSoft,
    required this.amberFaint,
    required this.amberLine,
    required this.onAmber,
    required this.green,
    required this.greenLine,
    required this.red,
    required this.redSoft,
    required this.redLine,
    required this.text,
    required this.textSecondary,
    required this.textMuted,
  });

  static const dark = AppColors(
    bg: Color(0xFF080C17),
    bgDeep: Color(0xFF0D1A3A),
    bgEnd: Color(0xFF07101F),
    surface: Color(0xFF0E1428),
    card: Color(0x0AFFFFFF), // 4% white
    border: Color(0x14FFFFFF), // 8% white
    rail: Color(0x26FFFFFF),
    amber: Color(0xFFFBBC24),
    amberSoft: Color(0x26FBBC24), // 15%
    amberFaint: Color(0x14FBBC24), // 8%
    amberLine: Color(0x4DFBBC24), // 30%
    onAmber: Color(0xFF1C1404),
    green: Color(0xFF22D3A5),
    greenLine: Color(0x4D22D3A5),
    red: Color(0xFFF87171),
    redSoft: Color(0x1AF87171),
    redLine: Color(0x4DF87171),
    text: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF94A3B8),
    textMuted: Color(0xFF64748B),
  );

  static const light = AppColors(
    bg: Color(0xFFF5F7FB),
    bgDeep: Color(0xFFEAF0FB),
    bgEnd: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    border: Color(0x1A0F172A), // 10% slate
    rail: Color(0x330F172A),
    amber: Color(0xFFB45309), // darker amber: 5:1 on white, for text too
    amberSoft: Color(0x1FB45309),
    amberFaint: Color(0x12B45309),
    amberLine: Color(0x4DB45309),
    onAmber: Color(0xFFFFFFFF),
    green: Color(0xFF059669),
    greenLine: Color(0x4D059669),
    red: Color(0xFFDC2626),
    redSoft: Color(0x14DC2626),
    redLine: Color(0x4DDC2626),
    text: Color(0xFF0F172A),
    textSecondary: Color(0xFF334155),
    textMuted: Color(0xFF475569),
  );

  /// The logo tile; the same in both themes.
  static const logoGradient = [Color(0xFFFBBC24), Color(0xFFF97316)];

  final Color bg;
  final Color bgDeep;
  final Color bgEnd;
  final Color surface;
  final Color card;
  final Color border;

  /// Line joining the stops in a journey.
  final Color rail;

  /// Money. The fares that answer the rider's question are amber.
  final Color amber;
  final Color amberSoft;
  final Color amberFaint;
  final Color amberLine;
  final Color onAmber;

  /// Boarding stop.
  final Color green;
  final Color greenLine;

  /// Destination stop and errors.
  final Color red;
  final Color redSoft;
  final Color redLine;

  final Color text;
  final Color textSecondary;
  final Color textMuted;

  @override
  AppColors copyWith() => this;

  // ponytail: snaps halfway instead of blending; lerp each color if the
  // theme switch animation ever looks abrupt.
  @override
  AppColors lerp(AppColors? other, double t) =>
      other == null || t < 0.5 ? this : other;
}

class AppText {
  AppText._(AppColors c)
      // Bangla strokes are thin at Regular/12px, so small text runs a size up
      // and at Medium weight to stay legible.
      : caption = TextStyle(
            fontSize: 13, height: 1.4, fontWeight: FontWeight.w500, color: c.textMuted),
        label = TextStyle(
            fontSize: 14, height: 1.4, fontWeight: FontWeight.w500, color: c.textSecondary),
        body = TextStyle(
            fontSize: 16, height: 1.5, fontWeight: FontWeight.w500, color: c.text),
        bodyStrong = TextStyle(
            fontSize: 16, height: 1.4, fontWeight: FontWeight.w600, color: c.text),
        title = TextStyle(
            fontSize: 20, height: 1.3, fontWeight: FontWeight.w700, color: c.text),
        display = TextStyle(
            fontSize: 26, height: 1.2, fontWeight: FontWeight.w700, color: c.text),
        fare = TextStyle(
            fontSize: 34, height: 1.0, fontWeight: FontWeight.w700, color: c.amber),
        fareHero = TextStyle(
            fontSize: 48, height: 1.0, fontWeight: FontWeight.w700, color: c.amber);

  static final _dark = AppText._(AppColors.dark);
  static final _light = AppText._(AppColors.light);

  static const family = 'HindSiliguri';

  final TextStyle caption;
  final TextStyle label;
  final TextStyle body;
  final TextStyle bodyStrong;
  final TextStyle title;
  final TextStyle display;

  /// The fare figure.
  final TextStyle fare;
  final TextStyle fareHero;
}

extension AppThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  AppText get text =>
      identical(colors, AppColors.light) ? AppText._light : AppText._dark;
}

ThemeData buildAppTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? AppColors.dark : AppColors.light;
  final scheme = ColorScheme.fromSeed(
    seedColor: c.amber,
    brightness: brightness,
  ).copyWith(
    primary: c.amber,
    onPrimary: c.onAmber,
    secondary: c.green,
    onSecondary: c.bg,
    surface: c.bg,
    onSurface: c.text,
    surfaceTint: Colors.transparent,
    error: c.red,
    onError: c.bg,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.bg,
    fontFamily: AppText.family,
    extensions: [c],
    dividerTheme: DividerThemeData(color: c.border, space: 1, thickness: 1),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: c.amber),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}

/// Shared input style (feedback form).
InputDecoration appInputDecoration(BuildContext context, String hint) {
  final c = context.colors;
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: c.textMuted),
    filled: true,
    fillColor: c.card,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c.amber, width: 1.5),
    ),
  );
}
