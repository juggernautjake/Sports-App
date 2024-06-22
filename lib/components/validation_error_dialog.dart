import 'package:flutter/material.dart';

class ValidationErrorDialog extends StatelessWidget {
  final String name;
  final String description;
  final String streetAddress;
  final String city;
  final String state;
  final String zipCode;

  ValidationErrorDialog({
    required this.name,
    required this.description,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Validation Error', style: Theme.of(context).textTheme.titleMedium),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Please fill out the following fields:', style: TextStyle(color: Colors.red)),
            if (name.isEmpty) Text('- Event Name', style: TextStyle(color: Colors.red)),
            if (description.isEmpty) Text('- Event Description', style: TextStyle(color: Colors.red)),
            if (streetAddress.isEmpty) Text('- Street Address', style: TextStyle(color: Colors.red)),
            if (city.isEmpty) Text('- City', style: TextStyle(color: Colors.red)),
            if (state.isEmpty) Text('- State', style: TextStyle(color: Colors.red)),
            if (zipCode.isEmpty) Text('- Zip Code', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Edit'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
