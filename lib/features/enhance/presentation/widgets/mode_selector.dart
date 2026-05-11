import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/enhancement_job.dart';

class ModeSelector extends StatelessWidget {
  final EnhancementMode selected;
  final ValueChanged<EnhancementMode> onChanged;

  const ModeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: EnhancementMode.values.map((mode) {
        final isSelected = mode == selected;
        return ChoiceChip(
          label: Text(_label(mode)),
          selected: isSelected,
          onSelected: (_) => onChanged(mode),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : null,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        );
      }).toList(),
    );
  }

  String _label(EnhancementMode mode) {
    return switch (mode) {
      EnhancementMode.enhance => 'Enhance',
      EnhancementMode.restoreFace => 'Restore Face',
      EnhancementMode.colorize => 'Colorize',
      EnhancementMode.removeWatermark => 'Remove Watermark',
      EnhancementMode.removeBackground => 'Remove BG',
    };
  }
}
