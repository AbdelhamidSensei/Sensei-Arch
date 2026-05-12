import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme textTheme(Locale locale) {
    final isArabic = locale.languageCode == 'ar';
    if (isArabic) {
      return GoogleFonts.tajawalTextTheme();
    }
    return GoogleFonts.plusJakartaSansTextTheme();
  }
}
