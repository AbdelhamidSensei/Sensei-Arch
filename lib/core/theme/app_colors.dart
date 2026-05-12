import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color brand = Color(0xFF2979FF);
  static const Color brandDark = Color(0xFF448AFF);
  static const Color accent = Color(0xFFFFC107);

  // Metro lines
  static const Color line1Red = Color(0xFFE53935);
  static const Color line2Yellow = Color(0xFFFDD835);
  static const Color line3Green = Color(0xFF43A047);

  // Line colors adapted for dark mode (brighter)
  static const Color line1RedDark = Color(0xFFEF5350);
  static const Color line2YellowDark = Color(0xFFFFEE58);
  static const Color line3GreenDark = Color(0xFF66BB6A);

  static Color lineColor(String lineId, [Brightness brightness = Brightness.light]) {
    final dark = brightness == Brightness.dark;
    switch (lineId) {
      case 'L1':
        return dark ? line1RedDark : line1Red;
      case 'L2':
        return dark ? line2YellowDark : line2Yellow;
      case 'L3':
        return dark ? line3GreenDark : line3Green;
      default:
        return dark ? brandDark : brand;
    }
  }

  static Color lineTextColor(String lineId) {
    return lineId == 'L2' ? Colors.black87 : Colors.white;
  }

  static String lineName(String lineId, String lang) {
    switch (lineId) {
      case 'L1':
        return lang == 'ar' ? 'الخط الأول' : 'Line 1';
      case 'L2':
        return lang == 'ar' ? 'الخط الثاني' : 'Line 2';
      case 'L3':
        return lang == 'ar' ? 'الخط الثالث' : 'Line 3';
      default:
        return lineId;
    }
  }
}
