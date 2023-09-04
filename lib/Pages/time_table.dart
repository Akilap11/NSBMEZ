import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeTable extends StatelessWidget {
  const TimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfCalendar(
          view: CalendarView.week,
          firstDayOfWeek: 1,
          //initialDisplayDate: DateTime(2023, 06, 05, 09, 00, 00),
          //initialSelectedDate: DateTime(2023, 06, 05, 09, 00, 00),
          dataSource: MeetingDateSource(getAppoinments()),
        ),
      ),
    );
  }
}

List<Appointment> getAppoinments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0); // Start at 9 am
  final DateTime endTime = DateTime(today.year, today.month, today.day, 17, 0, 0); // End at 5 pm

  meetings.add(Appointment(
    startTime: startTime,
    endTime: endTime,
    subject: 'Poya Day',
    color: Colors.yellow,
    recurrenceRule: 'FREQ=DAILY;INTERVAL=1;COUNT=10',
  ));
  return meetings;
}

class MeetingDateSource extends CalendarDataSource {
  MeetingDateSource(List<Appointment> source) {
    appointments = source;
  }
}
