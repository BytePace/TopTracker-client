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
}

class NetworkProjectDataSource implements IProjectDataSource {
  final Dio _dio;

  const NetworkProjectDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<List<ProjectDto>> getProjects() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    try {
      final response = await _dio
          .get('/web/projects?access_token=$access_token&archived=true');
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    try {
      final response = await _dio
          .get('/web/projects/$id?access_token=$access_token&archived=true');
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final Map<String, dynamic> userData = {"access_token": access_token};

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? access_token = prefs.getString("access_token");

    final Map<String, dynamic> projectData = {"access_token": access_token};

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
}
