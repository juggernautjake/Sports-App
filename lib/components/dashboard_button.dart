import 'package:flutter/material.dart';

class DashboardButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget screen;
  final Color color;

  DashboardButton({required this.label, required this.icon, required this.screen, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Button color
      ),
    );
  }
}
