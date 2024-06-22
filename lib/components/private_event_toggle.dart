import 'package:flutter/material.dart';

class PrivateEventToggle extends StatelessWidget {
  final bool isPrivate;
  final ValueChanged<bool> onToggle;

  PrivateEventToggle({required this.isPrivate, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Private Event'),
        Switch(
          value: isPrivate,
          onChanged: onToggle,
        ),
      ],
    );
  }
}
