import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LineChip extends StatelessWidget {
  final String lineId;
  final String label;
  final bool small;

  const LineChip({
    super.key,
    required this.lineId,
    required this.label,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.lineColor(lineId);
    final textColor = lineId == 'L2' ? Colors.black87 : Colors.white;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 10,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(small ? 4 : 6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
