import 'package:flutter/material.dart';

class StationSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const StationSearchBar({
    super.key,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
      ),
      onChanged: onChanged,
    );
  }
}
