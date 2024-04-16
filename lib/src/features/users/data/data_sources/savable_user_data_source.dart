import 'package:sqflite/sqlite_api.dart';
import 'package:tt_bytepace/src/database/database.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/user_dto.dart';
import 'package:tt_bytepace/src/features/users/models/dto/all_users_dto.dart';

abstract interface class ISavableUserDataSource {
  Future<void> revokeInvite(int invitationID);

  Future<void> addUser(int inviteID, int projectID, String name);

  Future<void> deleteUser(int projectId, int profileId);

  Future<List<UserDto>> getAllUsers();

  Future<void> updateAllUsers(List<UserDto> allUsers);

  Future<List<ProfileIdDto>> getAllProfileID();
}

class DbUserDataSource implements ISavableUserDataSource {
  final Database _database;
  const DbUserDataSource({required Database database})
      : _database = database;

  @override
  Future<void> addUser(int inviteID, int projectID, String name) async {
    await _database.insert(
      'Invites',
      {
        DbInvitesKeys.inviteID: inviteID,
        DbInvitesKeys.detailProjectID: projectID,
        DbInvitesKeys.name: name
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteUser(int projectId, int profileId) async {
    await _database.delete(
      'Users',
      where: '${DbUsersKeys.profileID} = ?',
      whereArgs: [profileId],
    );
    await _database.delete(
      'UserInfo',
      where:
          '${DbUserInfoKeys.detailProjectID} = ? AND ${DbUserInfoKeys.userID} = ?',
      whereArgs: [projectId, profileId],
    );
    await _database.delete(
      'UserEngagements',
      where:
          '${DbUserEngagementsKeys.detailProjectID} = ? AND ${DbUserEngagementsKeys.userEngagementsID} = ?',
      whereArgs: [projectId, profileId],
    );
    //await database.close();
  }

  @override
  Future<List<ProfileIdDto>> getAllProfileID() async {
    List<ProfileIdDto> profileIDList = [];
    final List<Map<String, dynamic>> detailProjectsMapList =
        await _database.query("Users");
    for (var element in detailProjectsMapList) {
      profileIDList.add(ProfileIdDto.fromMap(element));
    }

    return profileIDList;
  }

  @override
  Future<List<UserDto>> getAllUsers() async {
    List<UserDto> projectList = [];
    final List<Map<String, dynamic>> detailProjectsMapList =
        await _database.query("Users", distinct: true);
    for (var element in detailProjectsMapList) {
      projectList.add(UserDto.fromMap(element));
    }

    return projectList;
  }

  @override
  Future<void> revokeInvite(int invitationID) async {
    await _database.delete(
      'Invites',
      where: '${DbInvitesKeys.inviteID} = ?',
      whereArgs: [invitationID],
    );
  }

  @override
  Future<void> updateAllUsers(List<UserDto> allUsers) async {
    try {
      final batch = _database.batch();
      batch.delete("Users");
      await batch.commit();
      for (var user in allUsers) {
        batch.insert('Users', {
          DbUsersKeys.profileID: user.userID,
          DbUsersKeys.name: user.name,
          DbUsersKeys.email: user.email
        });
      }
      await batch.commit();
    } on Exception {
      throw Exception();
    }
  }
}
