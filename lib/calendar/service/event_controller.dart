import 'package:flutter/src/widgets/async.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:sqflite/sqflite.dart';

import 'package:y_alarm/calendar/models/event.dart';
import 'package:y_alarm/utils/database_helper.dart';

class EventController extends DataBaseHelper {
  final _tableName = 'events';

  static final EventController instance = EventController();

  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY,
        categories TEXT NOT NULL,
        dtstamp TEXT NOT NULL,
        lastModified TEXT NOT NULL,
        uid TEXT NOT NULL,
        dtstart TEXT NOT NULL,
        dtend TEXT NOT NULL,
        summary TEXT NOT NULL,
        location TEXT NOT NULL
      )
    ''');
  }

  Future<void> checkTable() async {
    Database database = await instance.database;
    try {
      await database.rawQuery('SELECT 1 FROM $_tableName').then((value) => value.isEmpty);
    } catch (e) {
      await onCreate(await database, super.dbVersion);
    }
  }

  Future<Event> create(Event event) async {
    await checkTable();
    Database db = await instance.database;
    event.id = await db.insert(_tableName, event.toJson());
    return event;
  }

  Future<Event> update(Event event) async {
    await checkTable();
    Database db = await instance.database;
    await db.update(
      _tableName,
      event.toJson(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
    return event;
  }

  Future<Event> get(int id) async {
    await checkTable();
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return Event.fromJson(maps.first);
  }

  Future<bool> exists(Event event) async {
    await checkTable();
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = [];
    if (event.id == null) {
      maps = await db.query(
        _tableName,
        where: 'uid = ? AND dtstart = ? AND dtend = ? AND summary = ? AND categories = ? AND dtstamp = ? AND lastModified = ? AND location = ?',
        whereArgs: [event.uid, event.dtstart.toIso8601String(), event.dtend.toIso8601String(), event.summary, event.categories, event.dtstamp.toIso8601String(), event.lastModified.toIso8601String(), event.location],
      );
    } else {
      maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [event.id],
      );
    }
    return maps.isNotEmpty;
  }

  Future<List<Event>> getAll() async {
    await checkTable();
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) => Event.fromJson(maps[i]));
  }

  Future<List<Event>> getForDay(DateTime day) async {
    await checkTable();
    Database db = await instance.database;
    day = DateTime(day.year, day.month, day.day);
    List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'dtstart <= ? AND dtend >= ?',
      whereArgs: [day.add(const Duration(days: 1)).toIso8601String(), day.toIso8601String()],
    );
    return List.generate(maps.length, (i) => Event.fromJson(maps[i]));
  }

  Future<void> delete(int id) async {
    await checkTable();
    Database db = await instance.database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Event> save(Event event) async {
    await checkTable();
    if (event.id == null) {
      return create(event);
    } else {
      return update(event);
    }
  }
}