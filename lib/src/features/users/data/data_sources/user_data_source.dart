import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/invite_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/user_dto.dart';
import 'package:tt_bytepace/src/features/users/models/dto/all_users_dto.dart';

abstract interface class IUserDataSource {
  Future<void> revokeInvite(int invitationID);

  Future<InvitedDto> addUser(String email, String rate, String role, int id);

  Future<void> deleteUser(int projectId, int profileId);

  Future<List<int>> getProjectsID();

  Future<List<UserDto>> getAllUsers();

  Future<List<ProfileIdDto>> getAllProfileID();
}

class NetworkUserDataSource implements IUserDataSource {
  final Dio _dio;
  final SharedPreferences _prefs;

  NetworkUserDataSource({required Dio dio, required SharedPreferences prefs})
      : _dio = dio,
        _prefs = prefs;

  @override
  Future<void> revokeInvite(int invitationID) async {
    String? accessToken = _prefs.getString("access_token");

    final Map<String, dynamic> userData = {'access_token': accessToken};
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
  Future<InvitedDto> addUser(
      String email, String rate, String role, int id) async {
    String? accessToken = _prefs.getString("access_token");
    final Map<String, dynamic> userData = {
      "invites": [
        {'email': email, 'rate': rate, 'role': role}
      ],
      "access_token": accessToken
    };
    final response =
        await _dio.post('/projects/$id/invitations', data: userData);
    if (response.statusCode == 201) {
      return InvitedDto.fromJson(response.data['invitations'][0]);
    } else {
      throw Exception();
    }
  }

  @override
  Future<void> deleteUser(int projectId, int profileId) async {
    String? accessToken = _prefs.getString("access_token");
    final Map<String, dynamic> userData = {'access_token': accessToken};

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
    String? accessToken = _prefs.getString("access_token");

    final responseIDs =
        await _dio.get('/web/projects?access_token=$accessToken&archived=true');
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
  Future<List<UserDto>> getAllUsers() async {
    String? accessToken = _prefs.getString("access_token");

    final List<int> listProjectIDs = await getProjectsID();
    final Map<int, UserDto> allUsers = {};
    for (int i = 0; i < listProjectIDs.length; i++) {
      final response2 = await _dio.get(
          '/projects/${listProjectIDs[i]}/engagements?access_token=$accessToken&archived=true');
      response2.data['workers'].forEach((element) {
        allUsers[element["id"]] = UserDto.fromJson(element);
      });
    }

    return allUsers.values.toList();
  }

  @override
  Future<List<ProfileIdDto>> getAllProfileID() async {
    String? accessToken = _prefs.getString("access_token");

    final response = await _dio
        .get('/reports/filters?access_token=$accessToken&archived=true');
    final List<ProfileIdDto> idList = [];
    response.data["filters"]['workers'].forEach((element) {
      idList
          .add(ProfileIdDto(profileID: element['id'], name: element["label"]));
    });
    return idList;
  }
}
