import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckInScreen extends StatelessWidget {
  final String eventId;
  final User? user = FirebaseAuth.instance.currentUser;

  CheckInScreen({required this.eventId});

  Future<void> _checkIn() async {
    try {
      await FirebaseFirestore.instance.collection('events').doc(eventId).update({
        'checkedInUsers': FieldValue.arrayUnion([user!.email]),
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check-in', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _checkIn,
            child: Text('Check-in'),
          ),
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('events').doc(eventId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var event = snapshot.data!;
                var checkedInUsers = event['checkedInUsers'] ?? [];
                return ListView.builder(
                  itemCount: checkedInUsers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(checkedInUsers[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
