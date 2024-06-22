import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class FriendRequestsScreen extends StatefulWidget {
  @override
  _FriendRequestsScreenState createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _suggestedUsers = [];
  List<DocumentSnapshot> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadSuggestedUsers();
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

  Future<void> _acceptFriendRequest(String friendId) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        var friendData = await FirebaseFirestore.instance.collection('users').doc(friendId).get();
        var friendName = friendData['name'];
        
        transaction.set(
          FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('friends').doc(friendId),
          {'name': friendName},
        );

        transaction.set(
          FirebaseFirestore.instance.collection('users').doc(friendId).collection('friends').doc(user!.uid),
          {'name': user!.displayName},
        );

        transaction.delete(
          FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('friendRequests').doc(friendId),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _denyFriendRequest(String friendId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('friendRequests').doc(friendId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _searchUsers(String query) async {
    var snapshot = await FirebaseFirestore.instance.collection('users')
      .where('name', isGreaterThanOrEqualTo: query)
      .where('name', isLessThanOrEqualTo: query + '\uf8ff')
      .get();
    setState(() {
      _searchResults = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Requests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search Users'),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _searchUsers(value);
                } else {
                  setState(() {
                    _searchResults = [];
                  });
                }
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('friendRequests').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  var requests = snapshot.data!.docs;
                  if (requests.isEmpty) {
                    return Center(child: Text("No friend requests at this time."));
                  }
                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      var request = requests[index];
                      var requestData = request.data() as Map<String, dynamic>;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        color: Colors.grey[800],
                        child: ListTile(
                          title: Text(requestData['name'], style: TextStyle(color: Colors.white)),
                          subtitle: Text(request.id),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () {
                                  _acceptFriendRequest(request.id);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.clear, color: Colors.red),
                                onPressed: () {
                                  _denyFriendRequest(request.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text('Suggested Users'),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.isNotEmpty ? _searchResults.length : _suggestedUsers.length,
                itemBuilder: (context, index) {
                  var user = _searchResults.isNotEmpty ? _searchResults[index] : _suggestedUsers[index];
                  return ListTile(
                    title: Text(user['name']),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _sendFriendRequest(user.id);
                      },
                      child: Text('Send Request'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendFriendRequest(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).collection('friendRequests').doc(user!.uid).set({
        'name': user!.displayName,
      });
    } catch (e) {
      print(e);
    }
  }
}
