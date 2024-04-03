import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();

    return _database!;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}TopTracker.db";
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE AllUsers(
          id INTEGER PRIMARY KEY,
          title TEXT,
          description TEXT,
          dueDate TEXT
        )
      ''');
    await db.execute('''
        CREATE TABLE Projects(
          id INTEGER PRIMARY KEY,
          title TEXT,
          description TEXT,
          dueDate TEXT
        )
      ''');
    await db.execute('''
        CREATE TABLE DetailProject(
          id INTEGER PRIMARY KEY,
          title TEXT,
          description TEXT,
          dueDate TEXT
        )
      ''');
  }
}
