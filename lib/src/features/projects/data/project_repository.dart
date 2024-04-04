import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/projects/data/data_sources/savable_project_data_source.dart';
import 'package:tt_bytepace/src/features/utils/methods.dart';
import 'package:tt_bytepace/src/features/projects/data/data_sources/project_data_source.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/project_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';

abstract interface class IProjectRepository {
  Future<List<ProjectModel>> getProjects();

  Future<DetailProjectModel> getDetailProject(int id);

  Future<void> restoreProject(BuildContext context, int projectID);

  Future<void> deleteProject(BuildContext context, int projectID);
}

class ProjectRepository implements IProjectRepository {
  final IProjectDataSource _networkProjectDataSource;
  final ISavableProjectDataSource _dbProjectDataSource;

  ProjectRepository(
      {required IProjectDataSource networkProjectDataSource,
      required ISavableProjectDataSource dbProjectDataSource})
      : _networkProjectDataSource = networkProjectDataSource,
        _dbProjectDataSource = dbProjectDataSource;

  @override
  Future<List<ProjectModel>> getProjects() async {
    var dtos = <ProjectDto>[];
    try {
      dtos = await _dbProjectDataSource.getProjects();
    } on Exception {
      //print("сделать обработку все проекты");
    }
    return dtos.map((e) => ProjectModel.fromDto(e)).toList();
  }

  @override
  Future<DetailProjectModel> getDetailProject(int id) async {
    await _dbProjectDataSource.deleteProject(id);
    var dto = const DetailProjectDto(
      users: [],
      invitations: [],
      id: 0,
      name: '',
      engagements: [],
      currentUserRole: '',
    );
    try {
      dto = await _dbProjectDataSource.getDetailProject(id);
    } catch (e){
      print("сделать обработку все проекты $e");
    }
    return DetailProjectModel.fromDto(dto);
  }

  @override
  Future<void> restoreProject(BuildContext context, int projectID) async {
    try {
      await _dbProjectDataSource.restoreProject(projectID);

      showCnackBar(context, "Проект разархивирован");
      Navigator.of(context).pop();
    } catch (e) {
      showCnackBar(context, "Произошла ошибка");
      print("Ошибка разархивирования проекта");
    }
  }

  @override
  Future<void> deleteProject(BuildContext context, int projectID) async {
    try {
      await _networkProjectDataSource.deleteProject(projectID);

      showCnackBar(context, "Проект удален");
      Navigator.of(context).pop();
    } catch (e) {
      print("Произошла ошибка при удалении");
      showCnackBar(context, "Произошла ошибка");
    }
  }
}
