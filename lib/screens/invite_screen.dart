import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InviteScreen extends StatelessWidget {
  final String eventId;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  InviteScreen({required this.eventId});

  Future<void> _inviteUser(String email) async {
    try {
      await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get().then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          var friendId = querySnapshot.docs[0].id;
          FirebaseFirestore.instance.collection('users').doc(friendId).collection('friendRequests').doc(user!.uid).set({
            'name': user!.displayName,
          });
        } else {
          print('User not found');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendInvites(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InviteDialog(eventId: eventId);
      },
    );
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
              onPressed: () => _inviteUser(_emailController.text),
              child: Text('Invite'),
            ),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('events').doc(eventId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  var event = snapshot.data!;
                  var invitedUsers = event['invitedFriends'] ?? [];
                  return ListView.builder(
                    itemCount: invitedUsers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(invitedUsers[index]),
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _sendInvites(context),
              child: Text('Send Invites'),
            ),
          ],
        ),
      ),
    );
  }
}

class InviteDialog extends StatefulWidget {
  final String eventId;
  InviteDialog({required this.eventId});

  @override
  _InviteDialogState createState() => _InviteDialogState();
}

class _InviteDialogState extends State<InviteDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _friends = [];
  List<DocumentSnapshot> _suggestedUsers = [];
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadFriends();
    _loadSuggestedUsers();
  }

  Future<void> _loadFriends() async {
    var snapshot = await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('friends').get();
    setState(() {
      _friends = snapshot.docs;
    });
  }

  Future<void> _loadSuggestedUsers() async {
    var userLocation = await _getUserLocation();
    var snapshot = await FirebaseFirestore.instance.collection('users')
      .where('location', isGreaterThanOrEqualTo: userLocation)
      .where('location', isLessThanOrEqualTo: userLocation + 100)
      .get();
    setState(() {
      _suggestedUsers = snapshot.docs;
    });
  }

  Future<int> _getUserLocation() async {
    // Mock function to get user location
    return 0; // Replace with actual location fetching logic
  }

  void _inviteUser(String userId) {
    FirebaseFirestore.instance.collection('events').doc(widget.eventId).update({
      'invitedFriends': FieldValue.arrayUnion([userId]),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Invite Users'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search'),
              onChanged: (value) {
                setState(() {
                  _friends = _friends.where((friend) {
                    var name = friend['name'] as String;
                    return name.toLowerCase().contains(value.toLowerCase());
                  }).toList();
                  _suggestedUsers = _suggestedUsers.where((user) {
                    var name = user['name'] as String;
                    return name.toLowerCase().contains(value.toLowerCase());
                  }).toList();
                });
              },
            ),
            SizedBox(height: 10),
            Text('Friends'),
            ..._friends.map((friend) {
              return ListTile(
                title: Text(friend['name']),
                trailing: ElevatedButton(
                  onPressed: () => _inviteUser(friend.id),
                  child: Text('Invite'),
                ),
              );
            }).toList(),
            SizedBox(height: 10),
            Text('Suggested Users'),
            ..._suggestedUsers.map((user) {
              return ListTile(
                title: Text(user['name']),
                trailing: ElevatedButton(
                  onPressed: () => _inviteUser(user.id),
                  child: Text('Invite'),
                ),
              );
            }).toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
