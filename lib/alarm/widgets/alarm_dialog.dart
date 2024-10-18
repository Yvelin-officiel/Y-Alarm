// lib/widgets/alarm_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import '../models/alarm.dart';

Future<Alarm?> showAlarmDialog(BuildContext context, int groupeId,
    {Alarm? existingAlarm}) {
  final TextEditingController nameController =
      TextEditingController(text: existingAlarm?.name ?? '');
  TimeOfDay selectedTime = existingAlarm?.time ?? TimeOfDay.now();
  List<String> selectedDays = existingAlarm?.repeatDays ?? [];
  final List<String> daysOfWeek = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche'
  ];

  return showDialog<Alarm>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(existingAlarm == null
                ? 'Ajouter un nouveau réveil'
                : 'Modifier le réveil'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      hintText:
                          'Nom du réveil (laisser vide pour nom par défaut)'),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Heure:'),
                    TextButton(
                      onPressed: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (pickedTime != null) {
                          setState(() {
                            selectedTime = pickedTime;
                          });
                        }
                      },
                      child: Text(selectedTime.format(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                const Text('Répéter les jours:'),
                Wrap(
                  spacing: 8.0,
                  children: daysOfWeek.map((day) {
                    final isSelected = selectedDays.contains(day);
                    return FilterChip(
                      label: Text(day),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedDays.add(day);
                          } else {
                            selectedDays.remove(day);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  final newAlarm = Alarm(
                    name: nameController.text.isNotEmpty
                        ? nameController.text
                        : 'Réveil à ${selectedTime.format(context)}', // Nom par défaut
                    time: selectedTime,
                    repeatDays: selectedDays,
                    isActive: existingAlarm?.isActive ?? true,
                    groupeId: groupeId,
                  );
                  FlutterAlarmClock.createAlarm(
                      hour: selectedTime.hour, minutes: selectedTime.minute);
                  Navigator.of(context).pop(
                      newAlarm); // Retourne la nouvelle alarme // Retourne la nouvelle alarme
                },
                child: const Text('Enregistrer'),
              ),
            ],
          );
        },
      );
    },
  );
}
