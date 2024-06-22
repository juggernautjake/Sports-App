import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onAccept;
  final VoidCallback onEdit;

  const ConfirmationDialog({
    required this.title,
    required this.content,
    required this.onAccept,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(content),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Edit'),
          onPressed: onEdit,
        ),
        TextButton(
          child: Text('Accept'),
          onPressed: onAccept,
        ),
      ],
    );
  }
}
