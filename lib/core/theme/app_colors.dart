import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryDark = Color(0xFF5345C9);
  static const Color accent = Color(0xFFFD79A8);
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFE17055);

  // Light
  static const Color bgLight = Color(0xFFF7F8FC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF2D3436);
  static const Color textSecondaryLight = Color(0xFF636E72);

  // Dark
  static const Color bgDark = Color(0xFF0F1115);
  static const Color surfaceDark = Color(0xFF1A1D24);
  static const Color textPrimaryDark = Color(0xFFF5F6FA);
  static const Color textSecondaryDark = Color(0xFFB2BEC3);

  // Gradients
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFFFD79A8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
