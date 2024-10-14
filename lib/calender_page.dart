import 'dart:io';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// Event model to include additional data
class Event {
  final String title; // Title for the event (e.g., "In Time" or "Out Time")
  final String imagePath; // To store image path
  final String time; // Store time
  final String location; // Store location
  final DateTime date; // Store the event date

  Event(this.title, {required this.imagePath, required this.time, required this.location, required this.date});

  @override
  String toString() => title;
}

class CalenderPage extends StatefulWidget {
  final List<Event> attendanceList; // Pass attendance data from AttendancePage

  const CalenderPage({Key? key, required this.attendanceList}) : super(key: key);

  @override
  _CalenderPageState createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();

    // Initialize the selected day and events
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    // Load attendance data into events map
    _loadAttendanceData();
  }

  void _loadAttendanceData() {
    for (var attendance in widget.attendanceList) {
      // Use the date from the Event instance directly
      DateTime date = attendance.date;
      if (_events[date] == null) {
        _events[date] = [];
      }
      _events[date]!.add(attendance);
    }
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Calendar'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              _selectedEvents.value = _getEventsForDay(selectedDay);
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              selectedBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
              todayBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(value[index].title),
                      subtitle: Text('Time: ${value[index].time}\nLocation: ${value[index].location}'),
                      leading: value[index].imagePath.isNotEmpty
                          ? Image.file(
                        File(value[index].imagePath),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : null, // Show image if available
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
