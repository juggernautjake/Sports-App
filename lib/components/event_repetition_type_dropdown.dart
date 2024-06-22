import 'package:flutter/material.dart';

class EventRepetitionTypeDropdown extends StatelessWidget {
  final String repetitionType;
  final ValueChanged<String?> onRepetitionTypeChanged;
  final bool submitted;

  const EventRepetitionTypeDropdown({
    required this.repetitionType,
    required this.onRepetitionTypeChanged,
    required this.submitted,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: DropdownButtonFormField<String>(
          value: repetitionType,
          decoration: InputDecoration(
            labelText: 'Repetition Type',
            border: OutlineInputBorder(),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            errorStyle: TextStyle(height: 0),
            suffixIcon: submitted && repetitionType.isEmpty ? Icon(Icons.error, color: Colors.red) : null,
          ),
          items: ['none', 'daily', 'weekly', 'monthly']
              .map((type) => DropdownMenuItem<String>(
                    value: type,
                    child: Text(type[0].toUpperCase() + type.substring(1)),
                  ))
              .toList(),
          onChanged: onRepetitionTypeChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
        ),
      ),
    );
  }
}
