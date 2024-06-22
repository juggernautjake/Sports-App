import 'package:flutter/material.dart';

class DateTimeErrorDialog extends StatelessWidget {
  final bool isStartDateTimeValid;
  final bool isEndDateTimeValid;

  DateTimeErrorDialog({
    required this.isStartDateTimeValid,
    required this.isEndDateTimeValid,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Date/Time Error', style: Theme.of(context).textTheme.titleMedium),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            if (!isStartDateTimeValid) Text('Start time cannot be in the past.', style: TextStyle(color: Colors.red)),
            if (!isEndDateTimeValid) Text('End time cannot be before start time.', style: TextStyle(color: Colors.red)),
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
