import 'package:sqflite/sqflite.dart';

import 'package:y_alarm/utils/database_helper.dart';
import 'package:y_alarm/alarm/service/alarm_group_controller.dart';
import 'package:y_alarm/alarm/models/alarm.dart';

class AlarmController extends DataBaseHelper {
  final _tableName = 'alarms';
  
  static final AlarmController instance = AlarmController();

  Future<void> checkTable() async {
    Database database = await instance.database;
    try {
      await database.rawQuery('SELECT 1 FROM $_tableName').then((value) => value.isEmpty);
    } catch (e) {
      await onCreate(await database, super.dbVersion);
    }
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        time TEXT NOT NULL,
        repeatDays TEXT NOT NULL,
        isActive INTEGER NOT NULL,
        groupeId INTEGER NOT NULL,
        FOREIGN KEY (groupeId) REFERENCES alarms_groupe(id)
      )
    ''');
  }

  Future<Alarm> create(Alarm alarm) async {
    await checkTable();
    Database db = await instance.database;
    alarm.id = await db.insert(_tableName, alarm.toJson());
    return alarm;
  }

  Future<Alarm> update(Alarm alarm) async {
    await checkTable();
    Database db = await instance.database;
    await db.update(
      _tableName,
      alarm.toJson(),
      where: 'id = ?',
      whereArgs: [alarm.id],
    );
    return alarm;
  }

  Future<Alarm> get(int id) async {
    await checkTable();
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return Alarm.fromJson(maps.first);
  }

  Future<List<Alarm>> getAll() async {
    await checkTable();
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Alarm.fromJson(maps[i]);
    });
  }

  Future<List<Alarm>> getAllByGroupId(int groupId) async {
    await checkTable();
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'groupeId = ?',
      whereArgs: [groupId],
    );
    return List.generate(maps.length, (i) {
      return Alarm.fromJson(maps[i]);
    });
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
}