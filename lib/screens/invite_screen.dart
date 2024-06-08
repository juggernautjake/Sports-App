import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InviteScreen extends StatelessWidget {
  final String eventId;
  final TextEditingController _emailController = TextEditingController();

  InviteScreen({required this.eventId});

  Future<void> _inviteUser() async {
    try {
      await FirebaseFirestore.instance.collection('events').doc(eventId).update({
        'invitedUsers': FieldValue.arrayUnion([_emailController.text]),
      });
      _emailController.clear();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'User Email'),
            ),
            ElevatedButton(
              onPressed: _inviteUser,
              child: Text('Invite'),
            ),
          ],
        ),
      ),
    );
  }
}
