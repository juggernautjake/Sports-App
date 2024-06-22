import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/event.dart';
import 'event_details_screen.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool _showFavorites = false;
  bool _showRSVPs = false;
  String _filterLocation = '';
  DateTime? _filterDate;

  void _toggleFavorites() {
    setState(() {
      _showFavorites = !_showFavorites;
    });
  }

  void _toggleRSVPs() {
    setState(() {
      _showRSVPs = !_showRSVPs;
    });
  }

  void _setFilterLocation(String location) {
    setState(() {
      _filterLocation = location;
    });
  }

  void _setFilterDate(DateTime date) {
    setState(() {
      _filterDate = date;
    });
  }

  Future<void> _toggleFavorite(Event event) async {
    if (user?.email != null) {
      final favorites = event.favorites;
      if (favorites.contains(user!.email!)) {
        favorites.remove(user!.email!);
      } else {
        favorites.add(user!.email!);
      }

      await FirebaseFirestore.instance.collection('events').doc(event.id).update({
        'favorites': favorites,
      });

      setState(() {});
    }
  }

  Future<void> _toggleRSVP(Event event) async {
    if (user?.email != null) {
      final rsvps = event.rsvps;
      if (rsvps.contains(user!.email!)) {
        rsvps.remove(user!.email!);
      } else {
        rsvps.add(user!.email!);
      }

      await FirebaseFirestore.instance.collection('events').doc(event.id).update({
        'rsvps': rsvps,
      });

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(_showFavorites ? Icons.star : Icons.star_border),
            onPressed: _toggleFavorites,
          ),
          IconButton(
            icon: Icon(_showRSVPs ? Icons.check_box : Icons.check_box_outline_blank),
            onPressed: _toggleRSVPs,
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              // Show filter dialog
              String? location = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController locationController = TextEditingController();
                  return AlertDialog(
                    title: Text('Filter by Location', style: Theme.of(context).textTheme.titleMedium),
                    content: TextField(
                      controller: locationController,
                      decoration: InputDecoration(labelText: 'Location'),
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Filter'),
                        onPressed: () {
                          Navigator.of(context).pop(locationController.text);
                        },
                      ),
                    ],
                  );
                },
              );

              if (location != null) {
                _setFilterLocation(location);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () async {
              // Show date picker
              DateTime? date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (date != null) {
                _setFilterDate(date);
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var events = snapshot.data!.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

          // Apply filters
          if (_showFavorites) {
            events = events.where((event) => event.favorites.contains(user?.email)).toList();
          }
          if (_showRSVPs) {
            events = events.where((event) => event.rsvps.contains(user?.email)).toList();
          }
          if (_filterLocation.isNotEmpty) {
            events = events.where((event) => event.location.contains(_filterLocation)).toList();
          }
          if (_filterDate != null) {
            events = events.where((event) => event.startTime.isSameDate(_filterDate!)).toList();
          }

          // Sort events by RSVP'd status and start time
          events.sort((a, b) {
            int rsvpComparison = (b.rsvps.contains(user?.email) ? 1 : 0) - (a.rsvps.contains(user?.email) ? 1 : 0);
            if (rsvpComparison != 0) return rsvpComparison;
            return a.startTime.compareTo(b.startTime);
          });

          // Display events
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                title: Text(event.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.description),
                    if (event.rsvps.contains(user?.email))
                      Text(
                        'RSVP\'d',
                        style: TextStyle(color: Colors.green),
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        event.rsvps.contains(user?.email) ? Icons.check_circle : Icons.check_circle_outline,
                        color: event.rsvps.contains(user?.email) ? Colors.green : null,
                      ),
                      onPressed: () => _toggleRSVP(event),
                    ),
                    IconButton(
                      icon: Icon(
                        event.favorites.contains(user?.email) ? Icons.star : Icons.star_border,
                        color: event.favorites.contains(user?.email) ? Colors.yellow : null,
                      ),
                      onPressed: () => _toggleFavorite(event),
                    ),
                  ],
                ),
                onTap: () {
                  // Navigate to event details
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventDetailsScreen(eventId: event.id)));
                },
              );
            },
          );
        },
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
