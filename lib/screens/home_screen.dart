import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'event_form.dart';
import 'events_screen.dart';
import 'event_details_screen.dart';
import 'check_in_screen.dart';
import 'invite_screen.dart';
import 'team_sign_up_screen.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sports App Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/event_form');
            },
          ),
          IconButton(
            icon: Icon(Icons.event),
            onPressed: () {
              Navigator.pushNamed(context, '/events');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
}
