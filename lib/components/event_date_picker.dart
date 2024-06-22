import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class EventDatePicker extends StatelessWidget {
  final DateTime eventDate;
  final ValueChanged<DateTime> onDateChanged;

  EventDatePicker({required this.eventDate, required this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Event Date', style: Theme.of(context).textTheme.titleMedium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 600.0,
            child: CalendarCarousel(
              onDayPressed: (DateTime date, List<dynamic> events) {
                onDateChanged(date);
              },
              weekendTextStyle: TextStyle(
                color: Colors.black,
              ),
              weekdayTextStyle: TextStyle(
                color: Colors.black,
              ),
              selectedDayTextStyle: TextStyle(
                color: Colors.white,
              ),
              thisMonthDayBorderColor: Colors.grey,
              selectedDateTime: eventDate,
              daysHaveCircularBorder: false,
              selectedDayButtonColor: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
