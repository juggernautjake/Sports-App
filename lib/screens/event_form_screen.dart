import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../components/confirmation_dialog.dart';
import '../components/datetime_error_dialog.dart';
import '../components/event_date_picker.dart';
import '../components/event_description_field.dart';
import '../components/event_location_fields.dart';
import '../components/event_name_field.dart';
import '../components/event_repetition_type_dropdown.dart';
import '../components/event_time_picker.dart' as time_picker;
import '../components/invite_friends_list.dart';
import '../components/private_event_toggle.dart';
import '../components/validation_error_dialog.dart';
import '../components/event_team_size_picker.dart' as team_size_picker;

class EventFormScreen extends StatefulWidget {
  final bool isEdit;
  final String? eventId;
  final Map<String, dynamic>? initialData;

  EventFormScreen({this.isEdit = false, this.eventId, this.initialData});

  @override
  _EventFormScreenState createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  DateTime _eventDate = DateTime.now();
  int _startHour = 12;
  int _startMinute = 0;
  String _startPeriod = 'AM';
  int _endHour = 12;
  int _endMinute = 0;
  String _endPeriod = 'AM';
  DateTime _checkInTime = DateTime.now();
  int _teamSize = 4;
  bool _isPrivate = false;
  bool _setTeamSize = false; // New toggle for setting team size
  List<String> _invitedFriends = [];
  String _repetitionType = 'none';

  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.initialData != null) {
      _loadEventData(widget.initialData!);
    }
  }

  void _loadEventData(Map<String, dynamic> data) {
    _nameController.text = data['name'];
    _descriptionController.text = data['description'];

    var location = data['location'].split(', ');
    if (location.length >= 4) {
      _streetAddressController.text = location[0];
      _cityController.text = location[1];
      _stateController.text = location[2];
      _zipCodeController.text = location[3];
    } else {
      _streetAddressController.text = '';
      _cityController.text = '';
      _stateController.text = '';
      _zipCodeController.text = '';
    }

    _eventDate = (data['startTime'] as Timestamp).toDate();
    DateTime startDateTime = (data['startTime'] as Timestamp).toDate();
    _startHour = startDateTime.hour > 12 ? startDateTime.hour - 12 : startDateTime.hour;
    _startMinute = startDateTime.minute;
    _startPeriod = startDateTime.hour >= 12 ? 'PM' : 'AM';
    DateTime endDateTime = (data['endTime'] as Timestamp).toDate();
    _endHour = endDateTime.hour > 12 ? endDateTime.hour - 12 : endDateTime.hour;
    _endMinute = endDateTime.minute;
    _endPeriod = endDateTime.hour >= 12 ? 'PM' : 'AM';
    _checkInTime = (data['checkInTime'] as Timestamp).toDate();
    _teamSize = data['teamSize'] ?? 4;
    _isPrivate = data['isPrivate'] ?? false;
    _invitedFriends = List<String>.from(data['invitedFriends'] ?? []);
    _repetitionType = data['repetitionType'] ?? 'none';
  }

  Future<void> _submitForm() async {
    setState(() {
      _submitted = true;
    });

    if (_formKey.currentState!.validate()) {
      _showConfirmationDialog();
    } else {
      _showValidationErrorDialog();
    }
  }

  void _showConfirmationDialog() {
    String address = '${_streetAddressController.text}, ${_cityController.text}, ${_stateController.text} ${_zipCodeController.text}';

    DateTime startDateTime = DateTime(
      _eventDate.year,
      _eventDate.month,
      _eventDate.day,
      _startPeriod == 'PM' && _startHour != 12 ? _startHour + 12 : _startHour,
      _startMinute,
    );
    DateTime endDateTime = DateTime(
      _eventDate.year,
      _eventDate.month,
      _eventDate.day,
      _endPeriod == 'PM' && _endHour != 12 ? _endHour + 12 : _endHour,
      _endMinute,
    );

    bool hasMissingFields = _nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _streetAddressController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _stateController.text.isEmpty ||
        _zipCodeController.text.isEmpty;

    bool isStartDateTimeValid = startDateTime.isAfter(DateTime.now());
    bool isEndDateTimeValid = endDateTime.isAfter(startDateTime);

    if (!isStartDateTimeValid || !isEndDateTimeValid) {
      _showDateTimeErrorDialog(isStartDateTimeValid, isEndDateTimeValid);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Confirm Event',
          content: 'Are you sure you want to submit this event?',
          onAccept: () async {
            try {
              final data = {
                'name': _nameController.text,
                'description': _descriptionController.text,
                'location': address,
                'startTime': Timestamp.fromDate(startDateTime),
                'endTime': Timestamp.fromDate(endDateTime),
                'checkInTime': Timestamp.fromDate(_checkInTime),
                'createdBy': FirebaseAuth.instance.currentUser!.email,
                'isPrivate': _isPrivate,
                'invitedFriends': _invitedFriends,
                'favorites': [],
                'rsvps': [],
                'checkedInUsers': [],
                'teamSize': _setTeamSize ? _teamSize : null,
                'teams': _setTeamSize ? List.generate(_teamSize, (index) => <String>[]) : null,
                'repetitionType': _repetitionType,
                'nextOccurrence': _calculateNextOccurrence(startDateTime),
              };

              if (widget.isEdit) {
                await FirebaseFirestore.instance.collection('events').doc(widget.eventId).update(data);
              } else {
                await FirebaseFirestore.instance.collection('events').add(data);
              }

              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Navigate back to the main page
            } catch (e) {
              print(e);
            }
          },
          onEdit: () {
            Navigator.of(context).pop(); // Close the dialog to allow editing
          },
        );
      },
    );
  }

  DateTime _calculateNextOccurrence(DateTime startDateTime) {
    switch (_repetitionType) {
      case 'daily':
        return startDateTime.add(Duration(days: 1));
      case 'weekly':
        return startDateTime.add(Duration(days: 7));
      case 'monthly':
        return DateTime(startDateTime.year, startDateTime.month + 1, startDateTime.day);
      default:
        return startDateTime;
    }
  }

  void _showValidationErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ValidationErrorDialog(
          name: _nameController.text,
          description: _descriptionController.text,
          streetAddress: _streetAddressController.text,
          city: _cityController.text,
          state: _stateController.text,
          zipCode: _zipCodeController.text,
        );
      },
    );
  }

  void _showDateTimeErrorDialog(bool isStartDateTimeValid, bool isEndDateTimeValid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DateTimeErrorDialog(
          isStartDateTimeValid: isStartDateTimeValid,
          isEndDateTimeValid: isEndDateTimeValid,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Event' : 'Create Event', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                EventNameField(controller: _nameController, submitted: _submitted),
                EventDescriptionField(controller: _descriptionController, submitted: _submitted),
                EventLocationFields(
                  streetAddressController: _streetAddressController,
                  cityController: _cityController,
                  stateController: _stateController,
                  zipCodeController: _zipCodeController,
                  submitted: _submitted,
                ),
                EventDatePicker(eventDate: _eventDate, onDateChanged: (date) => setState(() => _eventDate = date)),
                time_picker.EventTimePicker(
                  label: 'Start Time',
                  hour: _startHour,
                  minute: _startMinute,
                  period: _startPeriod,
                  onHourChanged: (hour) => setState(() => _startHour = hour),
                  onMinuteChanged: (minute) => setState(() => _startMinute = minute),
                  onPeriodChanged: (period) => setState(() => _startPeriod = period),
                ),
                time_picker.EventTimePicker(
                  label: 'End Time',
                  hour: _endHour,
                  minute: _endMinute,
                  period: _endPeriod,
                  onHourChanged: (hour) => setState(() => _endHour = hour),
                  onMinuteChanged: (minute) => setState(() => _endMinute = minute),
                  onPeriodChanged: (period) => setState(() => _endPeriod = period),
                ),
                time_picker.EventTimePicker(
                  label: 'Check-In Time',
                  hour: _checkInTime.hour,
                  minute: _checkInTime.minute,
                  period: _checkInTime.hour >= 12 ? 'PM' : 'AM',
                  onHourChanged: (hour) {
                    setState(() {
                      _checkInTime = DateTime(
                        _checkInTime.year,
                        _checkInTime.month,
                        _checkInTime.day,
                        _checkInTime.hour >= 12 && hour != 12 ? hour + 12 : hour,
                        _checkInTime.minute,
                      );
                    });
                  },
                  onMinuteChanged: (minute) {
                    setState(() {
                      _checkInTime = DateTime(
                        _checkInTime.year,
                        _checkInTime.month,
                        _checkInTime.day,
                        _checkInTime.hour,
                        minute,
                      );
                    });
                  },
                  onPeriodChanged: (period) {
                    setState(() {
                      int hour = _checkInTime.hour;
                      if (period == 'AM' && hour >= 12) {
                        hour -= 12;
                      } else if (period == 'PM' && hour < 12) {
                        hour += 12;
                      }
                      _checkInTime = DateTime(
                        _checkInTime.year,
                        _checkInTime.month,
                        _checkInTime.day,
                        hour,
                        _checkInTime.minute,
                      );
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Set Team Size', style: Theme.of(context).textTheme.titleMedium),
                    Switch(
                      value: _setTeamSize,
                      onChanged: (value) => setState(() => _setTeamSize = value),
                      activeColor: Colors.blue,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey.withOpacity(0.5),
                    ),
                  ],
                ),
                if (_setTeamSize)
                  team_size_picker.EventTeamSizePicker(
                    label: 'Team Size',
                    teamSize: _teamSize,
                    onTeamSizeChanged: (size) => setState(() => _teamSize = size),
                  ),
                EventRepetitionTypeDropdown(
                  repetitionType: _repetitionType,
                  onRepetitionTypeChanged: (type) => setState(() => _repetitionType = type!),
                  submitted: _submitted,
                ),
                PrivateEventToggle(
                  isPrivate: _isPrivate,
                  onToggle: (value) => setState(() => _isPrivate = value),
                ),
                if (_isPrivate) InviteFriendsList(
                  invitedFriends: _invitedFriends,
                  onInvitedFriendsChanged: (friends) => setState(() => _invitedFriends = friends),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(widget.isEdit ? 'Edit Event' : 'Create Event'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
