import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventId;
  final User? user = FirebaseAuth.instance.currentUser;

  EventDetailsScreen({required this.eventId});

  Future<void> _rsvp() async {
    try {
      await FirebaseFirestore.instance.collection('events').doc(eventId).update({
        'rsvps': FieldValue.arrayUnion([user!.email]),
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Column(
        children: [
          // Event details UI here
          ElevatedButton(
            onPressed: _rsvp,
            child: Text('RSVP'),
          ),
        ],
      ),
    );
  }
}
