import 'package:flutter_test/flutter_test.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';
import 'package:tt_bytepace/src/features/users/data/data_sources/savable_user_data_source.dart';
import 'package:tt_bytepace/src/features/users/data/data_sources/user_data_source.dart';
import 'package:tt_bytepace/src/features/users/data/user_repository.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/users/models/dto/all_users_dto.dart';

import '../../database_test.dart';

import 'data_sources/user_db_data_source_test.dart';
import 'data_sources/user_network_data_sources_test.dart';

void main() {
  late UserRepositoryTest userRepositoryTest;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    userRepositoryTest = UserRepositoryTest(
        networkUserDataSource: NetworkUserDataSourceTest(),
        dbUserDataSource:
            DbUserDataSourceTest(database: DBProviderTest.db.database));
  });
  group("User repository test", () {
    test(
        ' get allUsers network, update allUsers in db and get allUsers from db',
        () async {
      final users = await userRepositoryTest.updateAllUsers();
      final expectUsers = [UserModel(userID: 0, name: '', email: '')];
      expect(users,
          expectUsers); //получаем пользщователе с запроса и сохраняем в бд
      final usersFromDB = await userRepositoryTest.getAllUsers();
      expect(usersFromDB, expectUsers); //проверяем бд
    });
    test(
        ' get allUsers network, update allUsers in db and get allUsers from db',
        () async {
      final usersID = await userRepositoryTest.updateAllProfileID();
      final expectUsers = [ProfileIdModel(profileID: 0, name: '')];
      expect(usersID,
          expectUsers); //получаем пользщователе с запроса и сохраняем в бд
      final usersIDFromDB = await userRepositoryTest.getAllProfileID();
      expect(usersIDFromDB, expectUsers); //проверяем бд
    });

    test(' add user', () async {
      final database = await DBProviderTest.db.database;
      await userRepositoryTest.addUser("", "", "", 0);
      final users = await database
          .query("Invites", where: 'invite_id = ?', whereArgs: [10]);
      expect(users.isNotEmpty,
          true); //получаем приглашение если оно есть то правильно
    });
    test(' revoke user', () async {
      final database = await DBProviderTest.db.database;
      await userRepositoryTest.revokeInvite(10);
      final users = await database
          .query("Invites", where: "invite_id = ?", whereArgs: [10]);
      expect(users.isEmpty,
          true); //получаем приглашение если оно есть то правильно
    });
    test(' delete user', () async {
      final database = await DBProviderTest.db.database;
      await userRepositoryTest.delUser(1, 1);
      final users = await database.query(
        'Users',
        where: 'profile_id = ?',
        whereArgs: [1],
      );
      expect(users.isEmpty,
          true); //получаем приглашение если оно есть то правильно
    });
    test(' get all profile id', () async {
      final response = await userRepositoryTest.getProjectsID();

      expect(response, [1]);
    });
  });
}

class UserRepositoryTest implements IUserRepository {
  final IUserDataSource _networkUserDataSource;
  final ISavableUserDataSource _dbUserDataSource;

  UserRepositoryTest(
      {required IUserDataSource networkUserDataSource,
      required ISavableUserDataSource dbUserDataSource})
      : _networkUserDataSource = networkUserDataSource,
        _dbUserDataSource = dbUserDataSource;

  @override
  Future<void> addUser(
    String email,
    String rate,
    String role,
    int id,
  ) async {
    try {
      final invite =
          await _networkUserDataSource.addUser(email, rate, role, id);
      _dbUserDataSource.addUser(invite.inviteID, id, invite.name ?? "name");
    } catch (e) {
      print("ошибка добавления пользователя $e");
    }
  }

  @override
  Future<void> delUser(int projectId, int profileId) async {
    try {
      await _networkUserDataSource.deleteUser(projectId, profileId);
      await _dbUserDataSource.deleteUser(projectId, profileId);
    } catch (e) {
      print("ошибка удаления пользователя $e");
    }
  }

  @override
  Future<List<ProfileIdModel>> getAllProfileID() async {
    var dtos = <ProfileIdDto>[];
    try {
      dtos = await _dbUserDataSource.getAllProfileID();
    } catch (e) {
      print("Ошибка получения allprofileid $e");
    }
    return dtos.map((e) => ProfileIdModel.fromDto(e)).toList();
  }

  @override
  Future<List<ProfileIdModel>> updateAllProfileID() async {
    var dtos = <ProfileIdDto>[];
    try {
      dtos = await _networkUserDataSource.getAllProfileID();
    } catch (e) {
      print("Ошибка получения allprofileid $e");
    }
    return dtos.map((e) => ProfileIdModel.fromDto(e)).toList();
  }

  @override
  Future<List<UserModel>> updateAllUsers() async {
    var dtos = <UserDto>[];
    try {
      dtos = await _networkUserDataSource.getAllUsers();
      await _dbUserDataSource.updateAllUsers(dtos);
    } catch (e) {
      print("Ошибка получения updateAllUsers $e");
    }
    return dtos.map((e) => UserModel.fromDto(e)).toList();
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    var dtos = <UserDto>[];
    try {
      dtos = await _dbUserDataSource.getAllUsers();
    } catch (e) {
      print("Ошибка получения getAllUsers $e");
    }
    return dtos.map((e) => UserModel.fromDto(e)).toList();
  }

  @override
  Future<List<int>> getProjectsID() async {
    var dtos = <int>[];
    try {
      dtos = await _networkUserDataSource.getProjectsID();
    } catch (e) {
      print("Ошибка получения getProjectsID");
    }
    return dtos.map((e) => e).toList();
  }

  @override
  Future<void> revokeInvite(int invitationID) async {
    try {
      await _networkUserDataSource.revokeInvite(invitationID);
      await _dbUserDataSource.revokeInvite(invitationID);
    } catch (e) {
      print("произошла отмены приглашения ошибка $e");
    }
  }
}
