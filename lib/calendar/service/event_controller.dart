import 'package:sqflite/sqflite.dart';

import 'package:y_alarm/calendar/models/event.dart';
import 'package:y_alarm/utils/database_helper.dart';

class EventController extends DataBaseHelper {
  final _tableName = 'events';

  EventController._privateConstructor();
  static final EventController instance = EventController._privateConstructor();

  @override
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
        summary TEXT NOT NULL
      )
    ''');
  }

  Future<Event> create(Event event) async {
    Database db = await instance.database;
    event.id = await db.insert(_tableName, event.toJson());
    return event;
  }

  Future<Event> update(Event event) async {
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
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return Event.fromJson(maps.first);
  }

  Future<List<Event>> getAll() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) => Event.fromJson(maps[i]));
  }

  Future<void> delete(int id) async {
    Database db = await instance.database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Event> save(Event event) async {
    if (event.id == null) {
      return create(event);
    } else {
      return update(event);
    }
  }
}