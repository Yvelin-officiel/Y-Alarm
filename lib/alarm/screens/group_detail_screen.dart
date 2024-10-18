// lib/screens/group_details_screen.dart
import 'package:flutter/material.dart';

import 'package:y_alarm/alarm/models/alarm_group.dart';
import 'package:y_alarm/alarm/widgets/alarm_tile.dart';
import 'package:y_alarm/alarm/widgets/alarm_dialog.dart';
import 'package:y_alarm/alarm/service/alam_controller.dart';
import 'package:y_alarm/alarm/models/alarm.dart';

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
      body: FutureBuilder(
        future: AlarmController.instance.getAllByGroupId(widget.alarmGroup.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erreur lors du chargement des alarmes'));
          }
          final alarms = snapshot.data as List<Alarm>;
          return ListView.builder(
            itemCount: alarms.length,
            itemBuilder: (context, index) {
              final alarm = alarms[index];
              return AlarmTile(
                alarm: alarm,
                onToggle: (value) {
                  alarm.isActive = value;
                  AlarmController.instance.update(alarm);
                  setState(() {});
                },
                onEdit: () async {
                  final updatedAlarm = await showAlarmDialog(context, widget.alarmGroup.id!, existingAlarm: alarm);
                  if (updatedAlarm != null) {
                    print("hey");
                    await AlarmController.instance.update(updatedAlarm);
                    setState(() {});
                  }
                },
                onDelete: () async {
                  await AlarmController.instance.delete(alarm.id!);
                  setState(() {});
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newAlarm = await showAlarmDialog(context, widget.alarmGroup.id!);
          if (newAlarm != null) {
            AlarmController.instance.create(newAlarm);
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
