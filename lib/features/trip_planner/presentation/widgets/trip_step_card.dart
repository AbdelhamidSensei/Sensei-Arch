import 'package:flutter/material.dart';

class TripStepCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const TripStepCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
      ),
    );
  }
}
