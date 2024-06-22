import 'package:flutter/material.dart';

class EventTimePicker extends StatelessWidget {
  final String label;
  final int hour;
  final int minute;
  final String period;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;
  final ValueChanged<String> onPeriodChanged;

  const EventTimePicker({
    required this.label,
    required this.hour,
    required this.minute,
    required this.period,
    required this.onHourChanged,
    required this.onMinuteChanged,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_drop_up, size: 24, color: Colors.black),
                  onPressed: () => onHourChanged(hour == 12 ? 1 : hour + 1),
                ),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: TextEditingController(text: hour.toString().padLeft(2, '0')),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      int newHour = int.tryParse(value) ?? hour;
                      if (newHour > 0 && newHour <= 12) onHourChanged(newHour);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_drop_down, size: 24, color: Colors.black),
                  onPressed: () => onHourChanged(hour == 1 ? 12 : hour - 1),
                ),
              ],
            ),
            SizedBox(width: 4),
            Text(':', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(width: 4),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_drop_up, size: 24, color: Colors.black),
                  onPressed: () => onMinuteChanged(minute == 59 ? 0 : minute + 1),
                ),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: TextEditingController(text: minute.toString().padLeft(2, '0')),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      int newMinute = int.tryParse(value) ?? minute;
                      if (newMinute >= 0 && newMinute < 60) onMinuteChanged(newMinute);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_drop_down, size: 24, color: Colors.black),
                  onPressed: () => onMinuteChanged(minute == 0 ? 59 : minute - 1),
                ),
              ],
            ),
            SizedBox(width: 8),
            Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => onPeriodChanged('AM'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                        ),
                        backgroundColor: period == 'AM' ? Colors.blue : Colors.grey,
                        minimumSize: Size(32, 36),
                        padding: EdgeInsets.symmetric(horizontal: 4),
                      ),
                      child: Text('AM', style: TextStyle(fontSize: 12)),
                    ),
                    ElevatedButton(
                      onPressed: () => onPeriodChanged('PM'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                        ),
                        backgroundColor: period == 'PM' ? Colors.blue : Colors.grey,
                        minimumSize: Size(32, 36),
                        padding: EdgeInsets.symmetric(horizontal: 4),
                      ),
                      child: Text('PM', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
