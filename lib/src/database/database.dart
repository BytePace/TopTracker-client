import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

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
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'TrackerToptal2.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future close() async {
    var dbClient = db;
    _database = null;
    return dbClient.close();
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE UsersProfileID(
          ${DbUsersProfileIDKeys.profileID} INTEGER ,
          ${DbUsersProfileIDKeys.detailProjectID} INTEGER
        )
      ''');

    await db.execute('''
        CREATE TABLE Users(
          ${DbUsersKeys.profileID} INTEGER primary key,
          ${DbUsersKeys.name} TEXT,
          ${DbUsersKeys.email} TEXT
        )
      ''');

    await db.execute('''
        CREATE TABLE Projects(
          ${DbProjectsKeys.id} INTEGER PRIMARY KEY,
          ${DbProjectsKeys.name} TEXT,
          ${DbProjectsKeys.adminName} TEXT,
          ${DbProjectsKeys.createdAt} TEXT,
          ${DbProjectsKeys.currentUser} TEXT,
          ${DbProjectsKeys.archivedAt} TEXT NULL
        )
      ''');

    await db.execute('''
        CREATE TABLE DetailProject(
          ${DbDetailProjectKeys.detailProjectID} INTEGER PRIMARY KEY,
          ${DbDetailProjectKeys.name} TEXT,
          ${DbDetailProjectKeys.currentUserRole} TEXT
        )
      ''');

    await db.execute('''
        CREATE TABLE UserInfo(
          ${DbUserInfoKeys.userID} INTEGER,
          ${DbUserInfoKeys.detailProjectID} INTEGER,
          ${DbUserInfoKeys.name} TEXT,
          ${DbUserInfoKeys.email} TEXT,
          FOREIGN KEY(${DbUserInfoKeys.detailProjectID}) REFERENCES DetailProject(${DbDetailProjectKeys.detailProjectID})
        )
      ''');

    await db.execute('''
        CREATE TABLE Invites(
          ${DbInvitesKeys.inviteID} INTEGER PRIMARY KEY,
          ${DbInvitesKeys.detailProjectID} INTEGER,
          ${DbInvitesKeys.name} TEXT,
          FOREIGN KEY(${DbInvitesKeys.detailProjectID}) REFERENCES DetailProject(${DbDetailProjectKeys.detailProjectID})
        )
      ''');

    await db.execute('''
        CREATE TABLE UserEngagements(
          ${DbUserEngagementsKeys.userEngagementsID} INTEGER,
          ${DbUserEngagementsKeys.userID} INTEGER,
          ${DbUserEngagementsKeys.detailProjectID} INTEGER,
          ${DbUserEngagementsKeys.workedTotal} INTEGER,
          FOREIGN KEY(${DbUserEngagementsKeys.detailProjectID}) REFERENCES DetailProject(${DbDetailProjectKeys.detailProjectID})
        )
      ''');
  }
}

class DbUsersProfileIDKeys {
  static const profileID = "profile_id";
  static const detailProjectID = "detail_project_id";
}

class DbUsersKeys {
  static const profileID = "profile_id";
  static const name = "name";
  static const email = "email";
}

class DbProjectsKeys {
  static const id = "id";
  static const name = "name";
  static const adminName = "adminName";
  static const createdAt = "createdAt";
  static const currentUser = "currentUser";
  static const archivedAt = "archivedAt";
}

class DbDetailProjectKeys {
  static const detailProjectID = "detail_project_id";
  static const name = "name";
  static const currentUserRole = "currentUserRole";
}

class DbUserInfoKeys {
  static const userID = "userID";
  static const detailProjectID = "detail_project_id";
  static const name = "name";
  static const email = "email";
}

class DbInvitesKeys {
  static const inviteID = "invite_id";
  static const detailProjectID = "detail_project_id";
  static const name = "name";
}

class DbUserEngagementsKeys {
  static const userEngagementsID = "user_engagements_id";
  static const userID = "userID";
  static const detailProjectID = "detail_project_id";
  static const workedTotal = "workedTotal";
}
