import 'dart:convert';
import 'dart:io';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:tt_bytepace/src/features/menu/services_provider/project_provider.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';

void main() {
  late MockProjectServices mockProjectServices;
  setUp(() {
    mockProjectServices = MockProjectServices();
  });
  group("Testing the network call project services", () {
    test("get projects method", () async {
      List<ProjectModel> projects = await mockProjectServices.getProjects();
      List<ProjectModel> projectsExpect = [
        ProjectModel(
            id: 208305,
            name: "ИПР",
            adminName: "Tatiana Tytar",
            createdAt: "2018-04-06T12:56:24+06:00",
            profilesIDs: [377593],
            archivedAt: null)
      ];
      expect(projects, projectsExpect);
    });
    test("get detail project method", () async {
      DetailProjectModel? detailProjectModel =
          await mockProjectServices.getDetailProject(0);
      expect(detailProjectModel!.name == "Project Name", true);
    });

    test("get all users without on project method", () {
      List<UserEngagementsModel> engagements = [
        UserEngagementsModel(profileId: 1, workedTotal: 2),
        UserEngagementsModel(profileId: 2, workedTotal: 2)
      ];
      List<UserModel> allUsers = [
        UserModel(profileID: 1, name: "name", email: "email"),
        UserModel(profileID: 2, name: "name", email: "email"),
        UserModel(profileID: 3, name: "name", email: "email"),
        UserModel(profileID: 4, name: "name", email: "email")
      ];
      expect(
          mockProjectServices.getAllUsersWhithoutOnProject(
              engagements, allUsers),
          [
            UserModel(profileID: 3, name: "name", email: "email"),
            UserModel(profileID: 4, name: "name", email: "email")
          ]);
    });

    test("getListUsersOnProject method", () {
      List<UserEngagementsModel> engagements = [
        UserEngagementsModel(profileId: 1, workedTotal: 2),
        UserEngagementsModel(profileId: 2, workedTotal: 2)
      ];
      List<UserModel> allUsers = [
        UserModel(profileID: 1, name: "name", email: "email"),
        UserModel(profileID: 2, name: "name", email: "email"),
        UserModel(profileID: 3, name: "name", email: "email"),
        UserModel(profileID: 4, name: "name", email: "email")
      ];
      expect(mockProjectServices.getListUsersOnProject(engagements, allUsers), [
        UserModel(profileID: 1, name: "name", email: "email"),
        UserModel(profileID: 2, name: "name", email: "email")
      ]);
    });

    test("get all users profile id method", () {
      List<UserEngagementsModel> engagements = [
        UserEngagementsModel(profileId: 1, workedTotal: 2),
        UserEngagementsModel(profileId: 2, workedTotal: 2)
      ];
      List<ProfileID> allUsersProfileID = [
        ProfileID(profileID: 1, name: "name"),
        ProfileID(profileID: 2, name: "name"),
        ProfileID(profileID: 3, name: "name"),
        ProfileID(profileID: 4, name: "name"),
      ];
      expect(
          mockProjectServices.getListUsersProfileIDOnProject(
              engagements, allUsersProfileID),
          [
            ProfileID(profileID: 1, name: "name"),
            ProfileID(profileID: 2, name: "name")
          ]);
    });
  });
}

class MockProjectServices extends ProjectProvider {
  @override
  List<UserModel> getAllUsersWhithoutOnProject(
      List<UserEngagementsModel> engagements, List<UserModel> allUsers) {
    List<UserModel> list = List.from(allUsers);
    for (var usr in allUsers) {
      for (var user in engagements) {
        if (usr.profileID == user.profileId) {
          list.remove(usr);
          break;
        }
      }
    }
    return list;
  }

  @override
  Future<DetailProjectModel?> getDetailProject(int id) async {
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call //
      final response = {
        'project': {
          'id': 123,
          'name': 'Project Name',
          'current_user': {'role': 'admin'},
        },
        'users': [
          {'id': 1, 'name': 'User 1', 'email': 'user1@example.com'},
          {'id': 2, 'name': 'User 2', 'email': 'user2@example.com'}
        ],
        'invitations': [],
        'engagements': [
          {
            'profile_id': 1,
            'stats': {'worked_total': 10}
          },
          {
            'profile_id': 2,
            'stats': {'worked_total': 20}
          }
        ]
      };

      return Response(jsonEncode(response), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      });
    });
    final response = await mockHTTPClient.get(Uri.base);
    if (response.statusCode == 200) {
      return DetailProjectModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print(response.statusCode);
      return null;
    }
  }

  @override
  List<UserModel> getListUsersOnProject(
      List<UserEngagementsModel> engagements, List<UserModel> allUsers) {
    final List<UserModel> usersOnProject = [];
    for (var userEngagement in engagements) {
      for (var user in allUsers) {
        if (userEngagement.profileId == user.profileID) {
          usersOnProject.add(user);
        }
      }
    }
    return usersOnProject;
  }

  @override
  List<ProfileID> getListUsersProfileIDOnProject(
      List<UserEngagementsModel> engagements,
      List<ProfileID> allUsersProfileID) {
    final List<ProfileID> usersOnProject = [];
    for (var userEngagement in engagements) {
      for (var user in allUsersProfileID) {
        if (userEngagement.profileId == user.profileID) {
          usersOnProject.add(user);
        }
      }
    }
    return usersOnProject;
  }

  @override
  Future<List<ProjectModel>> getProjects() async {
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call
      final response = {
        "projects": [
          {
            "id": 208305,
            "name": "ИПР",
            "archived_at": null,
            "abilities": ["view_analytics", "add_mte", "use_webtracker"],
            "admin_id": 32700,
            "last_activity_time": "2024-03-23T23:32:00.000+06:00",
            "current_user": {
              "role": "worker",
              "joined": "2024-03-11T10:26:57.086+06:00",
              "creator": false
            },
            "profiles_ids": [377593],
            "is_admin_client": false,
            "created_at": "2018-04-06T12:56:24+06:00",
            "engagement_ids": [1663600],
            "admin_profile": {
              "name": "Tatiana Tytar",
              "email": "tatiana.tytar@bytepace.com",
              "id": 30471
            },
          },
        ]
      };

      return Response(jsonEncode(response), 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      });
    });
    final response = await mockHTTPClient.get(Uri.base);

    if (response.statusCode == 200) {
      final List<ProjectModel> projects = [];
      jsonDecode(utf8.decode(response.bodyBytes))["projects"]
          .forEach((json) => {projects.add(ProjectModel.fromJson(json))});
      return projects;
    } else {
      return [];
    }
  }

  @override
  Future<void> restoreProject(BuildContext context, int projectID) {
    // TODO: implement restoreProject
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProject(BuildContext context, int projectID) {
    // TODO: implement deleteProject
    throw UnimplementedError();
  }
}
