import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:y_alarm/calendar/models/event.dart';
import 'package:y_alarm/calendar/service/event_controller.dart';
import 'Edit_event.dart';

class Calendar extends StatefulWidget {
  final List<Event> events;
  final Function reload;

  const Calendar({Key? key, required this.events, required this.reload}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  List<Event> _getEventsForDay(DateTime day) {
    day = DateTime(day.year, day.month, day.day);
    List<Event> eventsList = [];
    for (Event event in widget.events) {
      if ((event.dtstart.isBefore(day) || event.dtstart.isAtSameMomentAs(day)) && (event.dtend.isAfter(day) || event.dtend.isAtSameMomentAs(day))) {
        eventsList.add(event);
      }
    }
    eventsList.sort((a, b) {
      return a.dtstart.compareTo(b.dtstart);
    });
    return eventsList;
  }

  @override
  Widget build(BuildContext context) {
    EventController eventController = EventController.instance;
    _selectedEvents.value = _getEventsForDay(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
        body: Center(
            child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              locale: 'en_US',
              eventLoader: _getEventsForDay,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Expanded(
                child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                  title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        value[index].summary),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (value[index].id != null) {
                                          eventController.delete(value[index].id!);
                                          widget.reload();
                                        };
                                      },
                                      icon: const Icon(Icons.delete)),
                                  IconButton(
                                    onPressed: () =>
                                    showDialog(
                                      context: context,
                                      builder: (context) => Edit_event(
                                        setState,
                                        widget.reload,
                                        value[index]
                                      )
                                    ),
                                    icon: const Icon(Icons.edit)),
                                ],
                              )),
                            );
                          });
                    }))
          ],
        )),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => Edit_event(
                      setState, widget.reload, null
                      ));
            })
    );
  }
}
