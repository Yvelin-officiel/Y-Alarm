import 'package:flutter/material.dart';


class Alarm {
  String id;
  String name;
  TimeOfDay time;
  List<String> repeatDays;
  bool isActive;

  Alarm({
    required this.id,
    required this.name,
    required this.time,
    this.repeatDays = const [],
    this.isActive = true,
  });
}
