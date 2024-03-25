import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/menu/ServicesProvider/project_provider.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/services/config.dart';

void main() {
  late MockProjectServices mockProjectServices;
  setUp(() {
    mockProjectServices = MockProjectServices();
  });
  group("Testing the network call project services", () {});
  test("get projects method", () async {
    List<ProjectModel> projects = await mockProjectServices.getProjects();
    List<ProjectModel> projectsExpect = [
      const ProjectModel(
          id: 208305,
          name: "ИПР",
          adminName: "Tatiana Tytar",
          createdAt: "2018-04-06T12:56:24+06:00",
          profilesIDs: [377593],
          archivedAt: null)
    ];
    expect(projects, projectsExpect);
  });
  test("Get detail project method", () async {
    DetailProjectModel? detailProjectModel =
        await mockProjectServices.getDetailProject(0);
    expect(detailProjectModel!.name == "Project Name", true);
  });


}

class MockProjectServices extends ProjectProvider {
  @override
  Future<void> deleteProject(BuildContext context, int projectID) {
    // TODO: implement deleteProject
    throw UnimplementedError();
  }

  @override
  List<UserModel> getAllUsersWhithoutOnProject(
      DetailProjectModel detailProjectModel, List<UserModel> allUsers) {
    // TODO: implement getAllUsersWhithoutOnProject
    throw UnimplementedError();
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
      DetailProjectModel detailProjectModel, List<UserModel> allUsers) {
    // TODO: implement getListUsersOnProject
    throw UnimplementedError();
  }

  @override
  List<ProfileID> getListUsersProfileIDOnProject(
      DetailProjectModel detailProjectModel, List<ProfileID> allUsers) {
    // TODO: implement getListUsersProfileIDOnProject
    throw UnimplementedError();
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
            "currency": "USD",
            "admin_id": 32700,
            "last_activity_time": "2024-03-23T23:32:00.000+06:00",
            "current_user": {
              "role": "worker",
              "joined": "2024-03-11T10:26:57.086+06:00",
              "creator": false
            },
            "profiles_ids": [377593],
            "pending_invitation_ids": [],
            "is_admin_client": false,
            "created_at": "2018-04-06T12:56:24+06:00",
            "engagement_ids": [1663600],
            "budget": null,
            "billable": false,
            "admin_profile": {
              "name": "Tatiana Tytar",
              "avatar_url": null,
              "phone": null,
              "email": "tatiana.tytar@bytepace.com",
              "address": null,
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
  Future<bool> restoreProject(BuildContext context, int projectID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final Map<String, dynamic> userData = {"access_token": access_token};

    final response = await http.put(
      Uri.parse('${Config.baseUrl}/projects/$projectID/dearchive'),
      body: json.encode(userData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
