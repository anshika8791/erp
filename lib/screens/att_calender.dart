import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceCalendarScreen extends StatelessWidget {
  final String subject;
  final List<Map<String, dynamic>> attendanceData;

  const AttendanceCalendarScreen({
    Key? key,
    required this.subject,
    required this.attendanceData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, List> events = {};

    for (var entry in attendanceData) {
      if (entry['subject'] == subject) {
        DateTime date = DateTime.parse(entry['date']);
        events[date] = [entry['status']];
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('$subject Attendance Calendar')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          focusedDay: DateTime.now(),
          firstDay: DateTime(2020),
          lastDay: DateTime(2100),
          eventLoader: (day) => events[day] ?? [],
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            defaultDecoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            weekendDecoration: BoxDecoration(
              color: Colors.red[100],
              shape: BoxShape.circle,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              if (events.containsKey(day)) {
                final status = events[day]![0];
                final color = status == 'Absent' ? Colors.red : Colors.green;
                return Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
