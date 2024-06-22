// components/friend_requests_notification.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/friend_requests_screen.dart';

class FriendRequestsNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('friendRequests').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return SizedBox.shrink();
        var requests = snapshot.data!.docs;
        if (requests.isEmpty) return SizedBox.shrink();
        return ListTile(
          title: Text(
            'Friend Requests',
            style: TextStyle(color: Colors.yellow),
          ),
          trailing: Icon(Icons.notifications, color: Colors.yellow),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => FriendRequestsScreen()));
          },
        );
      },
    );
  }
}
