import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';

part 'project_list_event.dart';
part 'project_list_state.dart';

class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  ProjectListBloc({required this.projectService, required this.userServices})
      : super(ProjectListInitial()) {
    on<LoadProjectEvent>(_onLoadProject);

    on<UpdateProjectEvent>(_onUpdateProject);
  }

  _onLoadProject(LoadProjectEvent event, Emitter<ProjectListState> emit) async {
    projects.isEmpty ? emit(ProjectListLoading()) : '';
    projects = await GetIt.I<ProjectService>().getProjects();
    allProfileID = await GetIt.I<UserServices>().getAllProfileID();
    emit(ProjectListLoaded(
        projects: projects,
        allProfileID: allProfileID,
        allUser: [UserModel(profileID: 0, name: "Loading...", email: "")]));
    allUser = await GetIt.I<UserServices>().checkAllUsers(allProfileID);
    emit(ProjectListLoaded(
        allUser: allUser, projects: projects, allProfileID: allProfileID));
  }

  _onUpdateProject(
      UpdateProjectEvent event, Emitter<ProjectListState> emit) async {
    projects = await GetIt.I<ProjectService>().getProjects();
    emit(ProjectListLoaded(
        allUser: allUser, projects: projects, allProfileID: allProfileID));
  }

  final ProjectService projectService;
  final UserServices userServices;
  List<ProjectModel> projects = [];
  List<ProfileID> allProfileID = [];
  List<UserModel> allUser = [];
}
