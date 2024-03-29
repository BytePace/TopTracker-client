import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:tt_bytepace/src/features/users/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/projects/data/data_sources/project_data_source.dart';
import 'package:tt_bytepace/src/features/users/services/users_services.dart';

part 'project_list_event.dart';
part 'project_list_state.dart';

class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  ProjectListBloc({required this.projectService, required this.userServices})
      : super(ProjectListInitial()) {
    on<LoadProjectEvent>(_onLoadProject);

    on<RestoreProjectEvent>(_onRestoreProject);

    on<DeleteProjectEvent>(_onDeleteProject);
  }

  _onLoadProject(LoadProjectEvent event, Emitter<ProjectListState> emit) async {
    projects.isEmpty ? emit(ProjectListLoading()) : '';
    projects = await GetIt.I<NetworkProjectDataSource>().getProjects();
    allProfileID = await GetIt.I<UserServices>().getAllProfileID();
    emit(ProjectListLoaded(
        projects: projects,
        allProfileID: allProfileID,
        allUser: [UserModel(profileID: 0, name: "Loading...", email: "")]));
    allUser = await GetIt.I<UserServices>().checkAllUsers(allProfileID);
    emit(ProjectListLoaded(
        allUser: allUser, projects: projects, allProfileID: allProfileID));
  }

  _onRestoreProject(
      RestoreProjectEvent event, Emitter<ProjectListState> emit) async {
    for (int i = 0; i < projects.length; i++) {
      if (projects[i].id == event.id) {
        projects[i].archivedAt = null;
        break;
      }
    }
    emit(ProjectListLoaded(
        allUser: allUser, projects: projects, allProfileID: allProfileID));
  }

  _onDeleteProject(
      DeleteProjectEvent event, Emitter<ProjectListState> emit) async {
    projects.removeWhere((element) => element.id == event.id);
    emit(ProjectListLoaded(
        allUser: allUser, projects: projects, allProfileID: allProfileID));
  }

  final NetworkProjectDataSource projectService;
  final UserServices userServices;
  List<ProjectModel> projects = [];
  List<ProfileID> allProfileID = [];
  List<UserModel> allUser = [];
}
