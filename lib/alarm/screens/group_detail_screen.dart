// lib/screens/group_details_screen.dart
import 'package:flutter/material.dart';
import '../models/alarm_group.dart';
import '../widgets/alarm_tile.dart';
import '../widgets/alarm_dialog.dart';

class GroupDetailsScreen extends StatefulWidget {
  final AlarmGroup alarmGroup;

  const GroupDetailsScreen({super.key, required this.alarmGroup});

  @override
  _GroupDetailsScreenState createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alarmGroup.name),
      ),
      body: ListView.builder(
        itemCount: widget.alarmGroup.alarms.length,
        itemBuilder: (context, index) {
          final alarm = widget.alarmGroup.alarms[index];
          return AlarmTile(
            alarm: alarm,
            onToggle: (value) {
              setState(() {
                alarm.isActive = value;
              });
            },
            onEdit: () async {
              final updatedAlarm = await showAlarmDialog(context, existingAlarm: alarm);
              if (updatedAlarm != null) {
                setState(() {
                  widget.alarmGroup.alarms[index] = updatedAlarm; // Met à jour l'alarme
                });
              }
            },
            onDelete: () {
              setState(() {
                widget.alarmGroup.alarms.removeAt(index); // Supprime l'alarme
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newAlarm = await showAlarmDialog(context);
          if (newAlarm != null) {
            setState(() {
              widget.alarmGroup.alarms.add(newAlarm); // Ajoute la nouvelle alarme
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
