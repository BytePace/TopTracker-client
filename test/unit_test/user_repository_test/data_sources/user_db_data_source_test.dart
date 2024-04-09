import 'package:sqflite/sqflite.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';
import 'package:tt_bytepace/src/features/users/data/data_sources/savable_user_data_source.dart';
import 'package:tt_bytepace/src/features/users/models/dto/all_users_dto.dart';

class DbUserDataSourceTest implements ISavableUserDataSource {
  final Future<Database> _database;
  const DbUserDataSourceTest({required Future<Database> database})
      : _database = database;

  @override
  Future<void> addUser(int inviteID, int projectID, String name) async {
    final database = await _database;
    await database.insert(
      'Invites',
      {'invite_id': inviteID, 'detail_project_id': projectID, "name": name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteUser(int projectId, int profileId) async {
    final database = await _database;
    await database.delete(
      'Users',
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );
    await database.delete(
      'UserInfo',
      where: 'detail_project_id = ? AND userID = ?',
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
        await database.query("Users");
    for (var element in detailProjectsMapList) {
      profileIDList.add(ProfileIdDto.fromMap(element));
    }
    print(profileIDList);
    return profileIDList;
  }

  @override
  Future<List<UserDto>> getAllUsers() async {
    final database = await _database;
    List<UserDto> projectList = [];
    final List<Map<String, dynamic>> detailProjectsMapList =
        await database.query("Users", distinct: true);
    for (var element in detailProjectsMapList) {
      projectList.add(UserDto.fromMap(element));
    }

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

  @override
  Future<void> updateAllUsers(List<UserDto> allUsers) async {
    try {
      final database = await _database;
      final batch = database.batch();
      batch.delete("Users");
      await batch.commit();
      for (var user in allUsers) {
        batch.insert('Users', {
          "profile_id": user.userID,
          "name": user.name,
          "email": user.email
        });
      }
      await batch.commit();
    } on Exception {
      throw Exception();
    }
  }
}
