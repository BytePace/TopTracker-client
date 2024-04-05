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
  }

  _onLoadProject(LoadProjectEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectListLoading());
    projects = await _projectRepository.getProjects();
    allProfileID = await _userRepository.getAllProfileID();
    allUser = await _userRepository.getAllUsers();
    
    emit(ProjectListLoaded(
        allUser: allUser, projects: projects, allProfileID: allProfileID));
  }

  _updateProject(UpdateProjectEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectListLoading());
    projects = await _projectRepository.getNetworkProjects();
    allProfileID = await _userRepository.updateAllProfileID();
    emit(ProjectListLoaded(
        projects: projects,
        allProfileID: allProfileID,
        allUser: [UserModel(profileID: 0, name: "Loading...", email: "")]));
    allUser = await _userRepository.updateAllUsers();
    await _projectRepository.updateProject(projects);
    emit(ProjectListLoaded(
        allUser: allUser, projects: projects, allProfileID: allProfileID));
  }

  _onRestoreProject(
      RestoreProjectEvent event, Emitter<ProjectState> emit) async {
    await _projectRepository.restoreProject(event.context, event.id);
    projects = await _projectRepository.getProjects();
    allProfileID = await _userRepository.getAllProfileID();
    allUser = await _userRepository.getAllUsers();
    emit(ProjectListLoaded(
        allUser: allUser, projects: projects, allProfileID: allProfileID));
  }

  _onDeleteProject(DeleteProjectEvent event, Emitter<ProjectState> emit) async {
    projects.removeWhere((element) => element.id == event.id);
    emit(ProjectListLoaded(
        allUser: allUser, projects: projects, allProfileID: allProfileID));
    _projectRepository.deleteProject(event.context, event.id);
  }
}
