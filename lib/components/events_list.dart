import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../screens/event_details_screen.dart';
import '../models/event.dart';

class EventsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          var events = snapshot.data!.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

          // Filter events to display
          events = events.where((event) => _filterEvents(event, user)).toList();

          if (events.isEmpty) {
            return Center(child: Text("NO EVENT INFORMATION TO DISPLAY AT THIS TIME", style: TextStyle(color: Colors.white)));
          }
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              var event = events[index];

              bool isActive = _isEventActive(event.startTime, event.endTime);
              bool isToday = _isEventToday(event.startTime);
              bool isFavorite = event.favorites.contains(user!.email);

              // Use startTime if the event is still ongoing, otherwise use nextOccurrence
              DateTime displayDate = event.startTime;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                color: Colors.grey[800],
                child: ListTile(
                  leading: Icon(Icons.circle, color: isActive ? Colors.green : (isToday ? Colors.yellow : Colors.grey)),
                  title: Text(event.title, style: TextStyle(color: Colors.white)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Created by: ${event.createdBy}\n'
                        '${event.description}\n'
                        'Location: ${event.location}\n'
                        'Date: ${_formatDate(displayDate)}\n'
                        'Start: ${_formatTime(displayDate)}\n'
                        'End: ${_formatTime(event.endTime)}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      if (event.rsvps.contains(user.email))
                        Text(
                          'RSVP\'d',
                          style: TextStyle(color: Colors.green),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: isFavorite ? Colors.yellow : null,
                    ),
                    onPressed: () {
                      _toggleFavorite(event.id, user.email!, isFavorite);
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventDetailsScreen(eventId: event.id)));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  bool _filterEvents(Event event, User? user) {
    DateTime now = DateTime.now();
    bool isExpired = event.endTime.isBefore(now);

    if (isExpired && event.repetitionType == 'none') return false;

    if (event.createdBy == user!.email) return true; // Always show events created by the current user

    if (event.isPrivate) {
      return event.invitedFriends.contains(user.email);
    }

    return true;
  }

  void _toggleFavorite(String eventId, String userEmail, bool isFavorite) async {
    DocumentReference eventRef = FirebaseFirestore.instance.collection('events').doc(eventId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot eventSnapshot = await transaction.get(eventRef);

      if (!eventSnapshot.exists) {
        throw Exception("Event does not exist!");
      }

      List<String> favorites = List<String>.from(eventSnapshot['favorites'] ?? []);

      if (isFavorite) {
        favorites.remove(userEmail);
      } else {
        favorites.add(userEmail);
      }

      transaction.update(eventRef, {
        'favorites': favorites,
      });
    });
  }

  bool _isEventActive(DateTime startTime, DateTime endTime) {
    DateTime now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  bool _isEventToday(DateTime startTime) {
    DateTime now = DateTime.now();
    return now.year == startTime.year && now.month == startTime.month && now.day == startTime.day;
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('EEEE, M/d/yyyy').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }
}
