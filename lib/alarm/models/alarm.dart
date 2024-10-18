import 'package:flutter/material.dart';


class Alarm {
  int? id;
  String name;
  TimeOfDay time;
  List<String> repeatDays;
  bool isActive;
  int groupeId;

  Alarm({
    this.id,
    required this.name,
    required this.time,
    this.repeatDays = const [],
    this.isActive = true,
    required this.groupeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'time': '${time.hour}:${time.minute}',
      'repeatDays': repeatDays.join('/'),
      'isActive': isActive ? 1 : 0,
      'groupeId': groupeId,
    };
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'],
      name: json['name'],
      time: TimeOfDay(
        hour: int.parse(json['time'].split(':')[0]),
        minute: int.parse(json['time'].split(':')[1]),
      ),
      repeatDays: List<String>.from(json['repeatDays'].split('/')),
      isActive: json['isActive'] == 1,
      groupeId: json['groupeId'],
    );
  }
}
