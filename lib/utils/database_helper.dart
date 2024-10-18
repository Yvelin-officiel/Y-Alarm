import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DataBaseHelper {
  final _dbName = 'YAlarm.db';
  final dbVersion = 1;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: dbVersion); // Utiliser une fonction abstraite
  }
}