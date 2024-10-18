import 'package:sqflite/sqflite.dart';

import 'package:y_alarm/utils/database_helper.dart';
import 'package:y_alarm/alarm/models/alarm_group.dart';

class AlarmGroupeController extends DataBaseHelper {
  final _tableName = 'alarms_groupe';

  
  static final AlarmGroupeController instance = AlarmGroupeController();

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
        name TEXT NOT NULL
      )
    ''');
  }

  Future<AlarmGroup> create(AlarmGroup alarmGroup) async {
    await checkTable();
    Database db = await instance.database;
    alarmGroup.id = await db.insert(_tableName, alarmGroup.toJson());
    return alarmGroup;
  }

  Future<AlarmGroup> update(AlarmGroup alarmGroup) async {
    await checkTable();
    Database db = await instance.database;
    await db.update(
      _tableName,
      alarmGroup.toJson(),
      where: 'id = ?',
      whereArgs: [alarmGroup.id],
    );
    return alarmGroup;
  }

  Future<AlarmGroup> get(int id) async {
    await checkTable();
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return AlarmGroup.fromJson(maps.first);
  }

  Future<List<AlarmGroup>> getAll() async {
    await checkTable();
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return AlarmGroup.fromJson(maps[i]);
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