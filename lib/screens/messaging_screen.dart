import 'package:flutter/material.dart';

class MessagingScreen extends StatelessWidget {
  final String? friendId;

  MessagingScreen({this.friendId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messaging'),
      ),
      body: Center(
        child: Text('This is the messaging screen.'),
      ),
    );
  }
}
