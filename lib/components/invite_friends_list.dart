import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InviteFriendsList extends StatelessWidget {
  final List<String> invitedFriends;
  final ValueChanged<List<String>> onInvitedFriendsChanged;

  InviteFriendsList({required this.invitedFriends, required this.onInvitedFriendsChanged});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('friends').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        var friends = snapshot.data!.docs;
        return Column(
          children: [
            Text('Invite Friends', style: Theme.of(context).textTheme.titleMedium),
            ListView.builder(
              shrinkWrap: true,
              itemCount: friends.length,
              itemBuilder: (context, index) {
                var friend = friends[index];
                var friendData = friend.data() as Map<String, dynamic>;
                bool isSelected = invitedFriends.contains(friendData['email']);
                return ListTile(
                  title: Text(friendData['name']),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      List<String> newInvitedFriends = List.from(invitedFriends);
                      if (value == true) {
                        newInvitedFriends.add(friendData['email']);
                      } else {
                        newInvitedFriends.remove(friendData['email']);
                      }
                      onInvitedFriendsChanged(newInvitedFriends);
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
