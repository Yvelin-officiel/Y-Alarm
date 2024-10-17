import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:y_alarm/calendar/models/event.dart';

class CalendarEvent extends StatelessWidget {

  Event event;
  DateTime? focusedDay;

  CalendarEvent({Key? key, required this.event, this.focusedDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    focusedDay ??= DateTime.now();
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(event.summary),
          Text(
            DateTime(focusedDay!.year, focusedDay!.month, focusedDay!.day).isAtSameMomentAs(DateTime(event.dtstart.year, event.dtstart.month, event.dtstart.day))
              ? DateFormat('hh:mm').format(event.dtstart)
              : DateFormat('yyyy-MM-dd – hh:mm').format(event.dtstart)
          ),
          Text(
            DateTime(focusedDay!.year, focusedDay!.month, focusedDay!.day).isAtSameMomentAs(DateTime(event.dtend.year, event.dtend.month, event.dtend.day))
              ? DateFormat('hh:mm').format(event.dtend)
              : DateFormat('yyyy-MM-dd – hh:mm').format(event.dtend)
          ),
        ],
      ),
    );
  }
}