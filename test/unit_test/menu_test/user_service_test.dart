import 'dart:convert';
import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:tt_bytepace/src/features/menu/services_provider/users_provider.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';

void main() {
  late MockUserServices mockUserServices;
  setUp(() {
    mockUserServices = MockUserServices();
  });
  group("Testing the network call user services", () {});
  test("get all project ID method", () async {
    List<int> projects = await mockUserServices.getProjectsID();
    List<int> projectsExpect = [1, 2];
    expect(projects, projectsExpect);
  });

  test("get all users method", () async {
    List<UserModel> allUsers = await mockUserServices.getAllUsers();
    List<UserModel> allUsersExpect = [
      UserModel(profileID: 1, name: "name", email: "email"),
      UserModel(profileID: 2, name: "name", email: "email")
    ];
    expect(allUsers, allUsersExpect);
  });

  test("get user projects method", () async {
    List<ProjectModel> projects = [
      ProjectModel(
          id: 1,
          name: "name",
          adminName: "adminName",
          createdAt: "createdAt",
          profilesIDs: [1, 2],
          archivedAt: null),
      ProjectModel(
          id: 2,
          name: "name",
          adminName: "adminName",
          createdAt: "createdAt",
          profilesIDs: [3],
          archivedAt: null)
    ];
    List<ProfileID> allUsersList = [
      ProfileID(profileID: 1, name: "name"),
      ProfileID(profileID: 2, name: "name")
    ];
    expect(mockUserServices.getUserProject(projects, allUsersList, 0), [
      ProjectModel(
          id: 1,
          name: "name",
          adminName: "adminName",
          createdAt: "createdAt",
          profilesIDs: [1, 2],
          archivedAt: null)
    ]);
  });

  test("get all profile ID method", () async {
    List<ProfileID> allUsersProfileID =
        await mockUserServices.getAllProfileID();
    List<ProfileID> allUsersProfileIDExpect = [
      ProfileID(profileID: 1, name: "name"),
      ProfileID(profileID: 2, name: "name")
    ];
    expect(allUsersProfileID, allUsersProfileIDExpect);
  });

  test("get all profile ID method", () async {
    List<ProfileID> allUsersProfileID2 = [
      ProfileID(profileID: 1, name: "name"),
      ProfileID(profileID: 2, name: "name")
    ];
    List<ProfileID> allUsersProfileID1 = [
      ProfileID(profileID: 1, name: "name")
    ];
    List<UserModel> allUsers =
        await mockUserServices.checkAllUsers(allUsersProfileID2);
    expect(allUsers.length == 2,
        allUsersProfileID2.length == 2); //когда пользователей с запроса равно
                                          //количеству пользователей которых мы сохранили
    expect(allUsers.length == 2,
        allUsersProfileID1.length == 1); //когда не равно сработает условие
                                          //и загрузит всех пользователей заново
  });
}

class MockUserServices extends UserProvider {
  @override
  Future<List<UserModel>> checkAllUsers(List<ProfileID> allProfileID) async {
    final List<UserModel> list = [
      UserModel(profileID: 1, name: "name", email: "email"),
      UserModel(profileID: 2, name: "name", email: "email")
    ];

    print("${list.length}   ${allProfileID.length}");

    if (list.length != allProfileID.length) {
      return await getAllUsers();
    }
    return list;
  }

  @override
  Future<List<ProfileID>> getAllProfileID() async {
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call
      final response = {
        "filters": {
          "workers": [
            {"id": 1, "label": "name"},
            {"id": 2, "label": "name"}
          ]
        }
      };

      return Response(jsonEncode(response), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      });
    });
    final response = await mockHTTPClient.get(Uri.base);
    final List<ProfileID> idList = [];
    jsonDecode(utf8.decode(response.bodyBytes))["filters"]['workers']
        .forEach((element) {
      idList.add(ProfileID(profileID: element['id'], name: element["label"]));
    });
    return idList;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final Map<int, UserModel> allUsers = {};

    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call
      final response = {
        "workers": [
          {
            "id": 1,
            "name": "name",
            "role": "admin",
            "email": "email",
          },
          {
            "id": 2,
            "name": "name",
            "role": "worker",
            "email": "email",
          },
        ]
      };

      return Response(jsonEncode(response), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      });
    });

    final response2 = await mockHTTPClient.get(Uri.base);

    jsonDecode(utf8.decode(response2.bodyBytes))['workers'].forEach((element) {
      allUsers[element["id"]] = UserModel.fromJson(element);
    });

    Map<String, dynamic> jsonMap = {};
    allUsers.forEach((key, value) {
      jsonMap[key.toString()] = value.toJson();
    });

    return allUsers.values.toList();
  }

  @override
  Future<List<int>> getProjectsID() async {
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call
      final response = {
        "projects": [
          {
            "id": 1,
            "archived_at": null,
          },
          {
            "id": 2,
            "archived_at": null,
          },
        ]
      };

      return Response(jsonEncode(response), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      });
    });
    final responseIDs = await mockHTTPClient.get(Uri.base);
    List<int> projectID = [];

    if (responseIDs.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(utf8.decode(responseIDs.bodyBytes));
      map['projects'].forEach((project) => {
            if (project['archived_at'] == null) {projectID.add(project['id'])}
          }); //достаю все id всех проектов
    }
    return projectID;
  }

  @override
  List<ProjectModel> getUserProject(
      List<ProjectModel> projects, List<ProfileID> allUsersList, int index) {
    List<ProjectModel> projectModelList = [];

    for (ProjectModel project in projects) {
      for (var userProfileID in project.profilesIDs) {
        if (userProfileID == allUsersList[index].profileID) {
          projectModelList.add(project);
        }
      }
    }
    return projectModelList;
  }

  @override
  Future<void> revokeInvite(int invitationID, BuildContext context) {
    // TODO: implement revokeInvite
    throw UnimplementedError();
  }

  @override
  Future<void> addUser(
      String email, String rate, String role, int id, BuildContext context) {
    // TODO: implement addUser
    throw UnimplementedError();
  }

  @override
  Future<void> delUser(int projectId, int profileId, BuildContext context) {
    // TODO: implement delUser
    throw UnimplementedError();
  }
}
