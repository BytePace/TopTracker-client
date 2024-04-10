import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tt_bytepace/src/features/projects/data/project_repository.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/features/users/data/user_repository.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/utils/methods.dart';

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
    print("1");
    emit(ProjectListLoading());
    print("2");
    try {

      projects = await _projectRepository.getProjects();
          print("22");
      print(projects);
    } catch (e) {
      print(e);
    }
    emit(ProjectListLoaded(
        projects: projects,
        allProfileID: allProfileID,
        allUser: [UserModel(userID: 0, name: "Loading...", email: "")]));
    allProfileID = await _userRepository.getAllProfileID();
    print("3");
    if (projects.isEmpty) {
      emit(ProjectListLoading());
      projects = await _projectRepository.getNetworkProjects();
      await _projectRepository.updateProject(projects);
      allProfileID = await _userRepository.updateAllProfileID();
      emit(ProjectListLoaded(
          projects: projects,
          allProfileID: allProfileID,
          allUser: [UserModel(userID: 0, name: "Loading...", email: "")]));
      print("4");
      allUser = await _userRepository.updateAllUsers();
    }
    allUser = await _userRepository.getAllUsers();
    print(projects);

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
      showCnackBar(event.context, "Нет интернета");
      emit(ProjectListLoaded(
          allUser: allUser, projects: projects, allProfileID: allProfileID));
    }
  }

  _onRestoreProject(
      RestoreProjectEvent event, Emitter<ProjectState> emit) async {
    try {
      await _projectRepository.restoreProject(event.id);
      showCnackBar(event.context, "Проект разархивирован");
      Navigator.of(event.context).pop();
      projects = await _projectRepository.getProjects();
      allProfileID = await _userRepository.getAllProfileID();
      allUser = await _userRepository.getAllUsers();
      emit(ProjectListLoaded(
          allUser: allUser, projects: projects, allProfileID: allProfileID));
    } catch (e) {
      print("Произошла ошибка при разахривации $e");
      showCnackBar(event.context, "Произошла ошибка");
    }
  }

  _onDeleteProject(DeleteProjectEvent event, Emitter<ProjectState> emit) async {
    try {
      _projectRepository.deleteProject(event.id);
      projects.removeWhere((element) => element.id == event.id);
      emit(ProjectListLoaded(
          allUser: allUser, projects: projects, allProfileID: allProfileID));
      showCnackBar(event.context, "Проект удален");
      Navigator.of(event.context).pop();
    } catch (e) {
      print("Произошла ошибка при удалении $e");
      showCnackBar(event.context, "Произошла ошибка");
    }
  }

  _archiveProject(ArchiveProjectEvent event, Emitter<ProjectState> emit) async {
    try {
      await _projectRepository.archiveProject(event.id);
      projects = await _projectRepository.getProjects();
      allProfileID = await _userRepository.getAllProfileID();
      allUser = await _userRepository.getAllUsers();
      emit(ProjectListLoaded(
          allUser: allUser, projects: projects, allProfileID: allProfileID));
      showCnackBar(event.context, "Проект архивирован");
      Navigator.of(event.context).pop();
    } catch (e) {
      print("Произошла ошибка при архивации $e");
      showCnackBar(event.context, "Произошла ошибка");
    }
  }
}
