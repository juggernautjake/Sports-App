import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeamSignUpScreen extends StatelessWidget {
  final String eventId;
  final User? user = FirebaseAuth.instance.currentUser;

  TeamSignUpScreen({required this.eventId});

  Future<void> _signUpForTeam() async {
    try {
      DocumentSnapshot eventDoc = await FirebaseFirestore.instance.collection('events').doc(eventId).get();
      List<dynamic> teamUsers = eventDoc['teamUsers'] ?? [];
      
      if (!teamUsers.contains(user!.email)) {
        await FirebaseFirestore.instance.collection('events').doc(eventId).update({
          'teamUsers': FieldValue.arrayUnion([user!.email]),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Sign-up'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _signUpForTeam,
          child: Text('Sign-up for Team'),
        ),
      ),
    );
  }
}
