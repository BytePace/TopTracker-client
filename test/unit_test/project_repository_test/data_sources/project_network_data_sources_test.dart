import 'package:tt_bytepace/src/features/projects/data/data_sources/project_data_source.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/project_dto.dart';

class NetworkProjectDataSourceTest implements IProjectDataSource {
  @override
  Future<List<ProjectDto>> getProjects() async {
    try {
      final Map<String, dynamic> response = {
        "projects": [
          {
            "id": 1,
            "name": "1",
            "archived_at": null,
            "current_user": {
              "role": "1",
              "joined": "1",
            },
            "profiles_ids": [1],
            "admin_profile": {
              "name": "Tatiana Tytar",
            },
            "created_at": "1",
            "engagement_ids": [1],
          }
        ]
      };

      final List<ProjectDto> projects = [];
      print((response)["projects"]);
      (response)["projects"]
          .forEach((json) => {projects.add(ProjectDto.fromJson(json))});

      return projects;
    } catch (e) {
      print("Ошибка загрузки проектов $e");
      throw Exception();
    }
  }

  @override
  Future<DetailProjectDto> getDetailProject(int id) async {
    try {
      final response = <String, dynamic>{
        "project": {
          "id": 208305,
          "name": "ИПР",
          "created_at": "2018-04-06T12:56:24+06:00",
          "engagement_ids": [],
          "archived_at": null,
          "current_user": {
            "role": "worker",
            "joined": "2024-03-11T10:26:57.086+06:00",
            "creator": false
          },
          "profiles_ids": [],
          "admin_profile": {
            "name": "Tatiana Tytar",
            "avatar_url": null,
            "phone": null,
            "email": "tatiana.tytar@bytepace.com",
            "address": null,
            "id": 30471
          }
        },
        "users": [],
        "engagements": [],
        "invitations": []
      };

      return DetailProjectDto.fromJson(response);
    } catch (e) {
      print("Ошибка загрузки деталей проекта $e");
      throw Exception();
    }
  }

  @override
  Future<void> archiveProject(int projectID) async {}

  @override
  Future<void> deleteProject(int projectID) async {}

  @override
  Future<void> restoreProject(int projectID) async {}
}
