// lib/widgets/alarm_tile.dart
import 'package:flutter/material.dart';
import '../models/alarm.dart';

class AlarmTile extends StatelessWidget {
  final Alarm alarm;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AlarmTile({
    Key? key,
    required this.alarm,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(alarm.name),
      subtitle: Text(
        'Réveil à ${alarm.time.format(context)} \nRépéter: ${alarm.repeatDays.isNotEmpty ? alarm.repeatDays.join(', ') : 'Aucun jour'}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: alarm.isActive,
            onChanged: onToggle,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
