import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final String createdBy;
  final bool isPrivate;
  final List<String> invitedFriends;
  final List<String> favorites;
  final List<String> rsvps;
  final String repetitionType;
  final DateTime? nextOccurrence;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.createdBy,
    required this.isPrivate,
    required this.invitedFriends,
    required this.favorites,
    required this.rsvps,
    required this.repetitionType,
    this.nextOccurrence,
  });

  factory Event.fromMap(Map<String, dynamic> map, String id) {
    var location = map['location']?.split(', ') ?? [];
    return Event(
      id: id,
      title: map['name'] ?? '',
      description: map['description'] ?? '',
      location: location.length >= 4
          ? '${location[0]}, ${location[1]}, ${location[2]} ${location[3]}'
          : '',
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      createdBy: map['createdBy'] ?? '',
      isPrivate: map['isPrivate'] ?? false,
      invitedFriends: List<String>.from(map['invitedFriends'] ?? []),
      favorites: List<String>.from(map['favorites'] ?? []),
      rsvps: List<String>.from(map['rsvps'] ?? []),
      repetitionType: map['repetitionType'] ?? 'none',
      nextOccurrence: map['nextOccurrence'] != null ? (map['nextOccurrence'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    var locationParts = location.split(', ');
    return {
      'name': title,
      'description': description,
      'location': locationParts.length >= 4
          ? '${locationParts[0]}, ${locationParts[1]}, ${locationParts[2]}, ${locationParts[3]}'
          : location,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'createdBy': createdBy,
      'isPrivate': isPrivate,
      'invitedFriends': invitedFriends,
      'favorites': favorites,
      'rsvps': rsvps,
      'repetitionType': repetitionType,
      'nextOccurrence': nextOccurrence != null ? Timestamp.fromDate(nextOccurrence!) : null,
    };
  }
}
