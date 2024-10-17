import 'alarm.dart';

class AlarmGroup {
  String id;
  String name;
  List<Alarm> alarms;

  AlarmGroup({
    required this.id,
    required this.name,
    this.alarms = const [],
  });
}
