import 'package:flutter/material.dart';

class EventTeamSizePicker extends StatelessWidget {
  final String label;
  final int teamSize;
  final ValueChanged<int> onTeamSizeChanged;

  const EventTeamSizePicker({
    required this.label,
    required this.teamSize,
    required this.onTeamSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_drop_up, size: 24, color: Colors.black),
                  onPressed: () => onTeamSizeChanged(teamSize == 16 ? 4 : teamSize + 1),
                ),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: TextEditingController(text: teamSize.toString().padLeft(2, '0')),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      int newSize = int.tryParse(value) ?? teamSize;
                      if (newSize >= 4 && newSize <= 16) onTeamSizeChanged(newSize);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_drop_down, size: 24, color: Colors.black),
                  onPressed: () => onTeamSizeChanged(teamSize == 4 ? 16 : teamSize - 1),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
