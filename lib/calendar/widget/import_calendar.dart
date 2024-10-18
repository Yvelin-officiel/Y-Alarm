import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:y_alarm/calendar/models/event.dart';
import 'package:y_alarm/calendar/service/event_controller.dart';

class ImportCalendar extends StatefulWidget {
  File? file;
  String? error;
  Function reload;

  ImportCalendar({Key? key, required this.file, required this.reload, this.error}) : super(key: key);

  @override
  _ImportCalendarState createState() => _ImportCalendarState();
}

class _ImportCalendarState extends State<ImportCalendar> {

  Future<void> getFilePicker() async {
    // only allow .ics files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ics'],
    );
    if (result != null) {
      File file = File(result.files.single.path ?? "");
      if (file.path.split(".").last != "ics") {
        setState(() {
          widget.error = "Invalid file type. Please select a .ics file.";
        });
        return;
      }
      setState(() {
        widget.file = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    EventController eventController = EventController.instance;

    String get_file_name(){
      if (widget.file != null && widget.file!.path != "") {
        return widget.file!.path.split("/").last;
      } else {
        return "Import Calendar";
      }
    }

    return AlertDialog(
      scrollable: true,
      title: const Text('Import Calendar'),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (widget.file != null) {
              String data = await widget.file!.readAsString();
              for (String icsEvent in data.split("BEGIN:VEVENT")) {
                if (icsEvent == "") {
                  continue;
                }
                Event event = Event.fromIcs(icsEvent);
                if (await eventController.exists(event)) {
                  event = await eventController.update(event);
                } else {
                  event = await eventController.create(event);
                }
              }
              Navigator.pop(context);
              widget.reload();
            }
          },
          child: const Text("Import"),
        ),
      ],
      content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            ElevatedButton(
              onPressed: () async {
                await getFilePicker();
              },
              child: Text(get_file_name()),
            ),
            if (widget.error != null) Text(widget.error!),
          ])
    ));
  }
}