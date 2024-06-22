// components/friends_list.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/messaging_screen.dart';
import '../screens/friend_requests_screen.dart';

class FriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('friends').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var friends = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    var friend = friends[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      color: Colors.grey[800],
                      child: ListTile(
                        title: Text(friend['name'], style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessagingScreen(friendId: friend.id)));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          StreamBuilder(
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
          ),
        ],
      ),
    );
  }
}
