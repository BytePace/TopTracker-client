import 'package:sqflite/sqlite_api.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';
import 'package:tt_bytepace/src/features/users/models/dto/all_users_dto.dart';

abstract interface class ISavableUserDataSource {
  Future<void> revokeInvite(int invitationID);

  Future<void> addUser(int inviteID, int projectID, String name);

  Future<void> deleteUser(int projectId, int profileId);

  Future<List<UserInfoDto>> getAllUsers();

  Future<List<ProfileIdDto>> getAllProfileID();
}

class DbUserDataSource implements ISavableUserDataSource {
  final Future<Database> _database;
  const DbUserDataSource({required Future<Database> database})
      : _database = database;

  @override
  Future<void> addUser(int inviteID, int projectID, String name) async {
    final database = await _database;
    await database.insert(
      'Invites',
      {'invite_id': inviteID, 'detail_project_id': projectID, "name": name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    //await database.close();
  }

  @override
  Future<void> deleteUser(int projectId, int profileId) async {
    final database = await _database;
    await database.delete(
      'Users',
      where: 'detail_project_id = ? AND profileId = ?',
      whereArgs: [projectId, profileId],
    );
    await database.delete(
      'UserInfo',
      where: 'detail_project_id = ? AND profile_id = ?',
      whereArgs: [projectId, profileId],
    );
    await database.delete(
      'UserEngagements',
      where: 'detail_project_id = ? AND user_engagaments_id = ?',
      whereArgs: [projectId, profileId],
    );
    //await database.close();
  }

  @override
  Future<List<ProfileIdDto>> getAllProfileID() async {
    final database = await _database;
    List<ProfileIdDto> profileIDList = [];
    final List<Map<String, dynamic>> detailProjectsMapList =
        await database.query("UserInfo", distinct: true);
    detailProjectsMapList.forEach((user) async {
      profileIDList.add(ProfileIdDto.fromMap(user));
    });
    //await database.close();
    return profileIDList;
  }

  @override
  Future<List<UserInfoDto>> getAllUsers() async {
    final database = await _database;
    List<UserInfoDto> projectList = [];
    final List<Map<String, dynamic>> detailProjectsMapList =
        await database.query("UserInfo", distinct: true);
    detailProjectsMapList.forEach((user) async {
      projectList.add(UserInfoDto.fromMap(user));
    });
    //await database.close();
    return projectList;
  }

  @override
  Future<void> revokeInvite(int invitationID) async {
    final database = await _database;
    await database.delete(
      'Invites',
      where: 'invite_id = ?',
      whereArgs: [invitationID],
    );
    //await database.close();
  }
}
