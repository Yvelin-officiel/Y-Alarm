import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:y_alarm/calendar/models/event.dart';
import 'package:y_alarm/calendar/service/event_controller.dart';
import 'package:y_alarm/calendar/widget/Calendar.dart';
// import 'calendar.dart';

class Calendar_Page extends StatefulWidget {
  const Calendar_Page({Key? key}) : super(key: key);

  @override
  State<Calendar_Page> createState() => _Calendar_PageState();
}

class _Calendar_PageState extends State<Calendar_Page> {
  List<Event> events = [];
  DateTime dtstart =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday));
  DateTime dtend = DateTime.now()
      .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: EventController.instance.getAll(),
      builder: (context, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Calendar'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
              
            );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        events = snapshot.data ?? [];
        return Calendar(events: events, reload: () => setState(() {}));
      }
    );
  }
}
