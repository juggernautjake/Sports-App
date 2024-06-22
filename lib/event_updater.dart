import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class EventUpdater {
  static final EventUpdater _singleton = EventUpdater._internal();

  factory EventUpdater() {
    return _singleton;
  }

  EventUpdater._internal();

  Timer? _timer;

  void start() {
    _timer = Timer.periodic(Duration(minutes: 15), (Timer t) => _checkAndUpdateEvents());
  }

  void stop() {
    _timer?.cancel();
  }

  void _checkAndUpdateEvents() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('events').get();
    for (var doc in snapshot.docs) {
      var eventData = doc.data() as Map<String, dynamic>;
      var eventId = doc.id;
      await _updateRecurringEvent(eventData, eventId);
    }
  }

  Future<void> _updateRecurringEvent(Map<String, dynamic> eventData, String eventId) async {
    DateTime now = DateTime.now();
    DateTime startTime = (eventData['startTime'] as Timestamp).toDate();
    DateTime endTime = (eventData['endTime'] as Timestamp).toDate();
    DateTime? nextOccurrence = eventData['nextOccurrence'] != null
        ? (eventData['nextOccurrence'] as Timestamp).toDate()
        : null;

    if (startTime.isBefore(now) && eventData['repetitionType'] != 'none') {
      DateTime newStartTime = nextOccurrence ?? startTime;
      DateTime newEndTime = newStartTime.add(endTime.difference(startTime));

      while (newStartTime.isBefore(now)) {
        switch (eventData['repetitionType']) {
          case 'daily':
            newStartTime = newStartTime.add(Duration(days: 1));
            break;
          case 'weekly':
            newStartTime = newStartTime.add(Duration(days: 7));
            break;
          case 'monthly':
            newStartTime = DateTime(newStartTime.year, newStartTime.month + 1, newStartTime.day);
            break;
          default:
            return;
        }
        newEndTime = newStartTime.add(endTime.difference(startTime));
      }

      await FirebaseFirestore.instance.collection('events').doc(eventId).update({
        'startTime': Timestamp.fromDate(newStartTime),
        'endTime': Timestamp.fromDate(newEndTime),
        'nextOccurrence': _calculateNextOccurrence(newStartTime, eventData['repetitionType']),
        'rsvps': [], // Clear RSVPs for the new occurrence
      });
    }
  }

  Timestamp _calculateNextOccurrence(DateTime startTime, String repetitionType) {
    switch (repetitionType) {
      case 'daily':
        return Timestamp.fromDate(startTime.add(Duration(days: 1)));
      case 'weekly':
        return Timestamp.fromDate(startTime.add(Duration(days: 7)));
      case 'monthly':
        return Timestamp.fromDate(DateTime(startTime.year, startTime.month + 1, startTime.day));
      default:
        return Timestamp.fromDate(startTime);
    }
  }
}
