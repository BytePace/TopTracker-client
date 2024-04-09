import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/users/data/data_sources/savable_user_data_source.dart';
import 'package:tt_bytepace/src/features/utils/methods.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';
import 'package:tt_bytepace/src/features/users/data/data_sources/user_data_source.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/users/models/dto/all_users_dto.dart';

abstract interface class IUserRepository {
  Future<void> revokeInvite(int invitationID, BuildContext context);

  Future<void> addUser(
      String email, String rate, String role, int id, BuildContext context);

  Future<void> delUser(int projectId, int profileId, BuildContext context);

  Future<List<int>> getProjectsID();

  Future<List<UserModel>> getAllUsers();

  Future<List<ProfileIdModel>> getAllProfileID();

  Future<List<ProfileIdModel>> updateAllProfileID();

  Future<List<UserModel>> updateAllUsers();
}

class UserRepository implements IUserRepository {
  final IUserDataSource _networkUserDataSource;
  final ISavableUserDataSource _dbUserDataSource;

  UserRepository(
      {required IUserDataSource networkUserDataSource,
      required ISavableUserDataSource dbUserDataSource})
      : _networkUserDataSource = networkUserDataSource,
        _dbUserDataSource = dbUserDataSource;

  @override
  Future<void> addUser(String email, String rate, String role, int id,
      BuildContext context) async {
    try {
      final invite =
          await _networkUserDataSource.addUser(email, rate, role, id);
      _dbUserDataSource.addUser(invite.inviteID, id, invite.name ?? "name");
      showCnackBar(context, "Пользователь добавлен");
    } catch (e) {
      print("ошибка добавления пользователя $e");
      showCnackBar(context, "Произошла ошибка ");
    }
  }

  @override
  Future<void> delUser(
      int projectId, int profileId, BuildContext context) async {
    try {
      await _networkUserDataSource.deleteUser(projectId, profileId);
      await _dbUserDataSource.deleteUser(projectId, profileId);
      showCnackBar(context, "Пользователь удален");
    } catch (e) {
      print("ошибка удаления пользователя $e");
      showCnackBar(context, "Произошла ошибка $e");
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
  Future<void> revokeInvite(int invitationID, BuildContext context) async {
    try {
      await _networkUserDataSource.revokeInvite(invitationID);
      await _dbUserDataSource.revokeInvite(invitationID);
      showCnackBar(context, "Приглашение отменено");
    } catch (e) {
      print("произошла отмены приглашения ошибка $e");
      showCnackBar(context, "Произошла ошибка");
    }
  }
}
