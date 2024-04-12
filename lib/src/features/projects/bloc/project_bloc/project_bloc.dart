import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tt_bytepace/src/features/projects/data/project_repository.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/features/users/data/user_repository.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final IProjectRepository _projectRepository;
  final IUserRepository _userRepository;

  List<ProjectModel> projects = [];
  List<ProfileIdModel> allProfileID = [];
  List<UserModel> allUser = [];
  ProjectBloc(
      {required IProjectRepository projectRepository,
      required IUserRepository userRepository})
      : _projectRepository = projectRepository,
        _userRepository = userRepository,
        super(ProjectInitial()) {
    on<LoadProjectEvent>(_onLoadProject);

    on<UpdateProjectEvent>(_updateProject);

    on<RestoreProjectEvent>(_onRestoreProject);

    on<DeleteProjectEvent>(_onDeleteProject);

    on<ArchiveProjectEvent>(_archiveProject);
  }

  _onLoadProject(LoadProjectEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectListLoading());
    try {
      projects = await _projectRepository.getProjects();
    } catch (e) {
      print(e);
    }
    emit(ProjectListLoaded(
        projects: projects,
        allProfileID: allProfileID,
        allUser: [UserModel(userID: 0, name: "Loading...", email: "")]));
    allProfileID = await _userRepository.getAllProfileID();
    if (projects.isEmpty) {
      projects = await _projectRepository.getNetworkProjects();
      await _projectRepository.updateProject(projects);
      allProfileID = await _userRepository.updateAllProfileID();
      emit(ProjectListLoaded(
          projects: projects,
          allProfileID: allProfileID,
          allUser: [UserModel(userID: 0, name: "Loading...", email: "")]));
      allUser = await _userRepository.updateAllUsers();
    }
    allUser = await _userRepository.getAllUsers();

    emit(ProjectListLoaded(
        allUser: allUser, projects: projects, allProfileID: allProfileID));
  }

  _updateProject(UpdateProjectEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectListLoading());
    try {
      projects = await _projectRepository.getNetworkProjects();
      allProfileID = await _userRepository.updateAllProfileID();
      emit(ProjectListLoaded(
          projects: projects,
          allProfileID: allProfileID,
          allUser: [UserModel(userID: 0, name: "Loading...", email: "")]));
      allUser = await _userRepository.updateAllUsers();
      await _projectRepository.updateProject(projects);
      emit(ProjectListLoaded(
          allUser: allUser, projects: projects, allProfileID: allProfileID));
    } catch (e) {
      emit(ProjectListMessage(message: "Нет интернета"));
      emit(ProjectListLoaded(
          allUser: allUser, projects: projects, allProfileID: allProfileID));
    }
  }

  _onRestoreProject(
      RestoreProjectEvent event, Emitter<ProjectState> emit) async {
    try {
      await _projectRepository.restoreProject(event.id);
      emit(ProjectListMessage(message: "Проект разархивирован"));
      projects = await _projectRepository.getProjects();
      allProfileID = await _userRepository.getAllProfileID();
      allUser = await _userRepository.getAllUsers();
      emit(ProjectListLoaded(
          allUser: allUser, projects: projects, allProfileID: allProfileID));
    } catch (e) {
      print("Произошла ошибка при разахривации $e");
      emit(ProjectListMessage(message: "Произошла ошибка"));
      emit(ProjectListLoaded(
          allUser: allUser, projects: projects, allProfileID: allProfileID));
    }
  }

  _onDeleteProject(DeleteProjectEvent event, Emitter<ProjectState> emit) async {
    try {
      _projectRepository.deleteProject(event.id);
      projects.removeWhere((element) => element.id == event.id);
      emit(ProjectListMessage(message: "Проект удален"));
      emit(ProjectListLoaded(
          allUser: allUser, projects: projects, allProfileID: allProfileID));
    } catch (e) {
      print("Произошла ошибка при удалении $e");
      emit(ProjectListMessage(message: "Произошла ошибка"));
      emit(ProjectListLoaded(
          allUser: allUser, projects: projects, allProfileID: allProfileID));
    }
  }

  _archiveProject(ArchiveProjectEvent event, Emitter<ProjectState> emit) async {
    try {
      await _projectRepository.archiveProject(event.id);
      projects = await _projectRepository.getProjects();
      allProfileID = await _userRepository.getAllProfileID();
      allUser = await _userRepository.getAllUsers();

      emit(ProjectListMessage(message: "Проект архивирован"));
      emit(ProjectListLoaded(
          allUser: allUser, projects: projects, allProfileID: allProfileID));
    } catch (e) {
      print("Произошла ошибка при архивации $e");
      emit(ProjectListMessage(message: "Произошла ошибка"));
      emit(ProjectListLoaded(
          allUser: allUser, projects: projects, allProfileID: allProfileID));
    }
  }
}
