import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:y_alarm/calendar/models/event.dart';
import 'package:y_alarm/calendar/service/event_controller.dart';

class Edit_event extends StatelessWidget {
    
  TextEditingController _categoriesController = TextEditingController();
  TextEditingController _uidController = TextEditingController();
  TextEditingController _dtstartController = TextEditingController();
  TextEditingController _dtendController = TextEditingController();

  Function setState;
  Function reload;
  Event? event;

  Edit_event(this.setState, this.reload, this.event);

  @override
  Widget build(BuildContext context) {
    EventController eventController = EventController.instance;

    if (event != null) {
      _categoriesController.text = event!.categories;
      _uidController.text = event!.uid;
      _dtstartController.text = event!.dtstart.toString();
      _dtendController.text = event!.dtend.toString();
    }

    return AlertDialog(
      scrollable: true,
      title: const Text('Add Event'),
      content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            TextFormField(
              controller: _categoriesController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Event Categories',
              ),
            ),
            TextFormField(
              controller: _uidController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Event Name',
              ),
            ),
            TextField(
              controller: _dtstartController, //editing controller of this TextField
              decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_month), //icon of text field
                  labelText: "Enter Start Date" //label text of field
                  ),
              readOnly:
                  true, //set it true, so that user will not able to edit text
              onTap: () async { _selectDate(context, _dtstartController); },
            ),
            TextField(
              controller: _dtendController, //editing controller of this TextField
              decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_month), //icon of text field
                  labelText: "Enter End Date" //label text of field
                  ),
              readOnly:
                  true, //set it true, so that user will not able to edit text
              onTap: () async { _selectDate(context, _dtendController); },
            )
          ])),
      actions: [
        ElevatedButton(
            onPressed: () {
              if (event == null) {
                Event event = Event(
                  categories: _categoriesController.text,
                  dtstamp: DateTime.now(),
                  lastModified: DateTime.now(),
                  uid: _uidController.text,
                  dtstart: DateTime.parse(_dtstartController.text),
                  dtend: DateTime.parse(_dtendController.text),
                  summary: _uidController.text,
                );
                Navigator.of(context).pop();
                _categoriesController.clear();
                _uidController.clear();
                _dtstartController.clear();
                _dtendController.clear();
                eventController.create(event);
              }
              else {
                event!.categories = _categoriesController.text;
                event!.uid = _uidController.text;
                event!.dtstart = DateTime.parse(_dtstartController.text);
                event!.dtend = DateTime.parse(_dtendController.text);
                event!.summary = _uidController.text;
                event!.lastModified = DateTime.now();
                eventController.update(event!);
                Navigator.of(context).pop();
              }
              reload();
            },
            child: Text('Save')),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    {
      DateTime? pickedDate = await showDatePicker(
        // wait for time picker popup
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      );

      TimeOfDay? pickedTime = await showTimePicker(
        // wait for time picker popup
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedDate != null && pickedTime != null) {

        pickedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        // DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
        //converting to DateTime so that we can further format on different pattern.
        String formattedTime = DateFormat('yyyy-MM-dd HH:mm').format(pickedDate);
        //DateFormat() is from intl package, you can format the time on any pattern you need.

        setState(() {
          controller.text = formattedTime; //set the value of text field.
        });
      } else {
        print("Time is not selected");
      }
  }}
}
