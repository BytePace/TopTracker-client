import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBProviderTest {
  DBProviderTest._();

  static final DBProviderTest db = DBProviderTest._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();

    return _database!;
  }

  Future<Database> _initDb() async {
    // Инициализация FFI базы данных sqflite
    sqfliteFfiInit();
    // Установка databaseFactory для FFI
    databaseFactory = databaseFactoryFfi;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (MethodCall methodCall) async {
      return '.';
    });
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'TrackerToptal.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE UsersProfileID(
          profile_id INTEGER ,
          detail_project_id INTEGER
        )
      ''');

    await db.execute('''
        CREATE TABLE Users(
          profile_id INTEGER primary key,
          name text,
          email text
        )
      ''');
    await db.execute('''
        CREATE TABLE Projects(
          id INTEGER PRIMARY KEY,
          name TEXT,
          adminName TEXT,
          createdAt TEXT,
          currentUser TEXT,
          archivedAt TEXT NULL
        )
      ''');
    await db.execute('''
        CREATE TABLE DetailProject(
         detail_project_id INTEGER PRIMARY KEY,
          name TEXT,
          currentUserRole TEXT
        )
      ''');
    await db.execute('''
        CREATE TABLE UserInfo(
           userID INTEGER,
          detail_project_id INTEGER,
          name text,
          email text,
          FOREIGN KEY(detail_project_id) REFERENCES DetailProject(detail_project_id)
        )
      ''');
    await db.execute('''
        CREATE TABLE Invites(
          invite_id INTEGER PRIMARY KEY,
           detail_project_id INTEGER,
          name TEXT,
           FOREIGN KEY(detail_project_id) REFERENCES DetailProject(detail_project_id)
        )
      ''');
    await db.execute('''
        CREATE TABLE UserEngagements(
           user_engagaments_id INTEGER,
           userID INTEGER,
          detail_project_id INTEGER,
          workedTotal INTEGER,
          FOREIGN KEY(detail_project_id) REFERENCES DetailProject(detail_project_id)
        )
      ''');
  }
}
