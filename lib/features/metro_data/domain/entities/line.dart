import 'package:flutter/material.dart';

class MetroLine {
  final String id;
  final String nameEn;
  final String nameAr;
  final Color color;
  final String shortLabel;

  const MetroLine({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.color,
    required this.shortLabel,
  });

  String localizedName(String languageCode) =>
      languageCode == 'ar' ? nameAr : nameEn;

  factory MetroLine.fromJson(Map<String, dynamic> json) => MetroLine(
        id: json['id'] as String,
        nameEn: json['nameEn'] as String,
        nameAr: json['nameAr'] as String,
        color: Color(int.parse((json['color'] as String).replaceFirst('#', '0xFF'))),
        shortLabel: json['shortLabel'] as String,
      );
}
