import 'package:flutter/material.dart';

class EventDescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final bool submitted;

  EventDescriptionField({required this.controller, required this.submitted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Event Description',
              border: OutlineInputBorder(),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              errorStyle: TextStyle(height: 0),
              suffixIcon: submitted && controller.text.isEmpty ? Icon(Icons.error, color: Colors.red) : null,
            ),
            maxLines: 7,
            onChanged: (value) {
              // Trigger any needed state changes
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
