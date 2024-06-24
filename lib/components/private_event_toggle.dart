import 'package:flutter/material.dart';

class PrivateEventToggle extends StatelessWidget {
  final bool isPrivate;
  final ValueChanged<bool> onToggle;

  const PrivateEventToggle({
    required this.isPrivate,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Private Event', style: Theme.of(context).textTheme.titleMedium),
        Switch(
          value: isPrivate,
          onChanged: onToggle,
          activeColor: Colors.blue, // Blue when active
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.withOpacity(0.5),
        ),
      ],
    );
  }
}
