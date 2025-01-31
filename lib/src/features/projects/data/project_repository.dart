import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tt_bytepace/src/features/projects/data/data_sources/savable_project_data_source.dart';
import 'package:tt_bytepace/src/features/projects/data/data_sources/project_data_source.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/detail_project_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/dto/project_dto.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';

abstract interface class IProjectRepository {
  Future<List<ProjectModel>> getProjects();

  Future<List<ProjectModel>> getNetworkProjects();

  Future<DetailProjectModel> getDetailProject(int id);

  Future<String> addWorkTime(
      int projectID, String startTime, String endTime, String description);

  Future<void> restoreProject(int projectID);

  Future<void> deleteProject(int projectID);

  Future<void> archiveProject(int projectID);

  Future<void> updateProject(List<ProjectModel> projects);
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
    } catch (e, st) {
      GetIt.I<Talker>().error("Ошибка getProjects", e, st);
    }
    return dtos.map((e) => ProjectModel.fromDto(e)).toList();
  }

  @override
  Future<List<ProjectModel>> getNetworkProjects() async {
    var dtos = <ProjectDto>[];
    try {
      dtos = await _networkProjectDataSource.getProjects();
    } on Exception {
      throw Exception;
    }
    return dtos.map((e) => ProjectModel.fromDto(e)).toList();
  }

  @override
  Future<DetailProjectModel> getDetailProject(int id) async {
    var dto = const DetailProjectDto(
      users: [],
      invitations: [],
      id: 0,
      name: '',
      engagements: [],
      currentUserRole: '',
    );
    try {
      dto = await _networkProjectDataSource.getDetailProject(id);
      await _dbProjectDataSource.updateDetailProject(dto);
    } catch (e) {
      dto = await _dbProjectDataSource.getDetailProject(id);
      GetIt.I<Talker>().info("no connection wi fi", e);
    }
    return DetailProjectModel.fromDto(dto);
  }

  @override
  Future<void> restoreProject(int projectID) async {
    await _networkProjectDataSource.restoreProject(projectID);

    await _dbProjectDataSource.restoreProject(projectID);
  }

  @override
  Future<void> deleteProject(int projectID) async {
    await _networkProjectDataSource.deleteProject(projectID);
    await _dbProjectDataSource.deleteProject(projectID);
  }

  @override
  Future<void> updateProject(List<ProjectModel> projects) async {
    await _dbProjectDataSource.updateProject(projects);
  }

  @override
  Future<void> archiveProject(int projectID) async {
    try {
      await _networkProjectDataSource.archiveProject(projectID);
      await _dbProjectDataSource.archiveProject(projectID);
    } catch (e) {
      GetIt.I<Talker>().error("archiveProject error", e);
    }
  }

  @override
  Future<String> addWorkTime(int projectID, String startTime, String endTime,
      String description) async {
    return await _networkProjectDataSource.addWorkTime(
        projectID, startTime, endTime, description);
  }
}
