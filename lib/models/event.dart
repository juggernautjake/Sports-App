import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime checkInTime;
  final String createdBy;
  final bool isPrivate;
  final List<String> invitedFriends;
  final List<String> favorites;
  final List<String> rsvps;
  final List<String> checkedInUsers;
  final int teamSize;
  final List<List<String>> teams;
  final String repetitionType;
  final DateTime? nextOccurrence;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.checkInTime,
    required this.createdBy,
    required this.isPrivate,
    required this.invitedFriends,
    required this.favorites,
    required this.rsvps,
    required this.checkedInUsers,
    required this.teamSize,
    required this.teams,
    required this.repetitionType,
    this.nextOccurrence,
  });

  factory Event.fromMap(Map<String, dynamic> map, String id) {
    return Event(
      id: id,
      title: map['name'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      checkInTime: (map['checkInTime'] as Timestamp).toDate(),
      createdBy: map['createdBy'] ?? '',
      isPrivate: map['isPrivate'] ?? false,
      invitedFriends: List<String>.from(map['invitedFriends'] ?? []),
      favorites: List<String>.from(map['favorites'] ?? []),
      rsvps: List<String>.from(map['rsvps'] ?? []),
      checkedInUsers: List<String>.from(map['checkedInUsers'] ?? []),
      teamSize: map['teamSize'] ?? 4,
      teams: (map['teams'] as List<dynamic>).map((e) => List<String>.from(e)).toList(),
      repetitionType: map['repetitionType'] ?? 'none',
      nextOccurrence: map['nextOccurrence'] != null ? (map['nextOccurrence'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': title,
      'description': description,
      'location': location,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'checkInTime': Timestamp.fromDate(checkInTime),
      'createdBy': createdBy,
      'isPrivate': isPrivate,
      'invitedFriends': invitedFriends,
      'favorites': favorites,
      'rsvps': rsvps,
      'checkedInUsers': checkedInUsers,
      'teamSize': teamSize,
      'teams': teams,
      'repetitionType': repetitionType,
      'nextOccurrence': nextOccurrence != null ? Timestamp.fromDate(nextOccurrence!) : null,
    };
  }
}
