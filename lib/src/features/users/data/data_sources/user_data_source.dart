import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/users/models/dto/all_users_dto.dart';

abstract interface class IUserDataSource {
  Future<void> revokeInvite(int invitationID);

  Future<void> addUser(String email, String rate, String role, int id);

  Future<void> delUser(int projectId, int profileId);

  Future<List<int>> getProjectsID();

  Future<List<UserInfoDto>> getAllUsers();

  Future<List<ProfileIdDto>> getAllProfileID();

  Future<List<UserInfoDto>> checkAllUsers(List<ProfileIdModel> allProfileID);
}

class NetworkUserDataSource implements IUserDataSource {
  final Dio _dio;

  NetworkUserDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<void> revokeInvite(int invitationID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final Map<String, dynamic> userData = {'access_token': access_token};
    print(invitationID);
    final response = await _dio.delete(
      data: userData,
      '/invitations/$invitationID',
    );
    if (response.statusCode == 200) {
    } else {
      throw Exception();
    }
  }

  @override
  Future<void> addUser(String email, String rate, String role, int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final Map<String, dynamic> userData = {
      "invites": [
        {'email': email, 'rate': rate, 'role': role}
      ],
      "access_token": access_token
    };

    final response =
        await _dio.post('/projects/$id/invitations', data: userData);
    if (response.statusCode == 201) {
    } else {
      throw Exception();
    }
  }

  @override
  Future<void> delUser(int projectId, int profileId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");
    final Map<String, dynamic> userData = {'access_token': access_token};

    final response = await _dio.delete(
      data: userData,
      '/projects/$projectId/workers/$profileId',
    );
    if (response.statusCode == 200) {
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<int>> getProjectsID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final responseIDs = await _dio
        .get('/web/projects?access_token=$access_token&archived=true');
    List<int> projectID = [];

    if (responseIDs.statusCode == 200) {
      json.decode(responseIDs.data)['projects'].forEach((project) => {
            if (project['archived_at'] == null) {projectID.add(project['id'])}
          }); //достаю все id всех проектов
    } else {
      throw Exception();
    }
    return projectID;
  }

  @override
  Future<List<UserInfoDto>> getAllUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final List<int> listProjectIDs = await getProjectsID();
    final Map<int, UserInfoDto> allUsers = {};
    for (int i = 0; i < listProjectIDs.length; i++) {
      final response2 = await _dio.get(
          '/projects/${listProjectIDs[i]}/engagements?access_token=$access_token&archived=true');
      response2.data['workers'].forEach((element) {
        allUsers[element["id"]] = UserInfoDto.fromJson(element);
      });
    }
    Map<String, dynamic> jsonMap = {};
    allUsers.forEach((key, value) {
      jsonMap[key.toString()] = value.toJson();
    });
    prefs.setString("allUser", json.encode(jsonMap));

    return allUsers.values.toList();
  }

  @override
  Future<List<ProfileIdDto>> getAllProfileID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final response = await _dio
        .get('/reports/filters?access_token=$access_token&archived=true');
    final List<ProfileIdDto> idList = [];
    response.data["filters"]['workers'].forEach((element) {
      idList
          .add(ProfileIdDto(profileID: element['id'], name: element["label"]));
    });
    return idList;
  }

  @override
  Future<List<UserInfoDto>> checkAllUsers(
      List<ProfileIdModel> allProfileID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final allUsersString = prefs.getString("allUser") ?? "{}";

    List<UserInfoDto> list = [];
    json.decode(allUsersString).forEach((key, value) {
      list.add(UserInfoDto.fromJson(value));
    });
    if (list.length != allProfileID.length) {
      return await getAllUsers();
    }
    return list;
  }
}
