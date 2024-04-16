import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/project_dto.dart';

abstract class IProjectDataSource {
  Future<List<ProjectDto>> getProjects();

  Future<DetailProjectDto> getDetailProject(int id);

  Future<void> restoreProject(int projectID);

  Future<void> deleteProject(int projectID);

  Future<void> archiveProject(int projectID);
}

class NetworkProjectDataSource implements IProjectDataSource {
  final Dio _dio;
  final SharedPreferences _prefs;

  const NetworkProjectDataSource(
      {required Dio dio, required SharedPreferences prefs})
      : _dio = dio,
        _prefs = prefs;

  @override
  Future<List<ProjectDto>> getProjects() async {
    String? accessToken = _prefs.getString("access_token");

    try {
      final response = await _dio
          .get('/web/projects?access_token=$accessToken&archived=true');
      if (response.statusCode == 200) {
        final List<ProjectDto> projects = [];

        json
            .decode(response.data)["projects"]
            .forEach((json) => {projects.add(ProjectDto.fromJson(json))});

        return projects;
      } else {
        print("Ошибка загрузки проектов");
        throw Exception();
      }
    } catch (e) {
      print("Ошибка загрузки проектов $e");
      throw Exception();
    }
  }

  @override
  Future<DetailProjectDto> getDetailProject(int id) async {
    String? accessToken = _prefs.getString("access_token");

    try {
      final response = await _dio
          .get('/web/projects/$id?access_token=$accessToken&archived=true');
      if (response.statusCode == 200) {
        return DetailProjectDto.fromJson(response.data);
      } else {
        print("Ошибка загрузки деталей проекта");
        throw Exception();
      }
    } catch (e) {
      print("Ошибка загрузки деталей проекта");
      throw Exception();
    }
  }

  @override
  Future<void> restoreProject(int projectID) async {
    String? accessToken = _prefs.getString("access_token");

    final Map<String, dynamic> userData = {"access_token": accessToken};

    try {
      final response = await _dio.put(
        '/projects/$projectID/dearchive',
        data: userData,
      );

      if (response.statusCode == 200) {
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> deleteProject(int projectID) async {
    String? accessToken = _prefs.getString("access_token");

    final Map<String, dynamic> projectData = {"access_token": accessToken};

    try {
      final response =
          await _dio.delete('/projects/$projectID', data: projectData);

      if (response.statusCode == 204) {
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> archiveProject(int projectID) async {
    String? accessToken = _prefs.getString("access_token");

    final Map<String, dynamic> projectData = {"access_token": accessToken};

    try {
      final response =
          await _dio.put('/projects/$projectID/archive', data: projectData);

      if (response.statusCode == 200) {}
    } catch (e) {
      print(e);
    }
  }
}
