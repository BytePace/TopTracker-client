import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';

part 'project_list_event.dart';
part 'project_list_state.dart';

class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  ProjectListBloc() : super(const ProjectListInitial(projects: [], allProfileID: [], allUser: [])) {
    on<LoadProjectEvent>((event, emit) async {
      emit(const ProjectListLoading(projects: [], allProfileID: [], allUser: []));
      final List<ProjectModel> projects =
          await event.projectService.getProjects();
      final List<ProfileID> allProfileID =
          await event.userServices.getAllProfileID();
          
      emit(ProjectListLoaded(
          projects: projects,
          allProfileID: allProfileID,
          allUser: [UserModel(profileID: 0, name: "Loading...", email: "")]));
      final allUsers = await event.userServices.checkAllUsers(allProfileID);
      emit(ProjectListWithUserLoad(
          allUser: allUsers, projects: projects, allProfileID: allProfileID));
    });

    on<UpdateProjectEvent>((event, emit) async {
      final List<ProjectModel> projects =
          await event.projectService.getProjects();
      final List<ProfileID> allProfileID =
          await event.userServices.getAllProfileID();
      emit(ProjectListLoaded(
          projects: projects,
          allProfileID: allProfileID,
          allUser: [UserModel(profileID: 0, name: "Loading...", email: "")]));
      final allUsers = await event.userServices.checkAllUsers(allProfileID);
      emit(ProjectListWithUserLoad(
          allUser: allUsers, projects: projects, allProfileID: allProfileID));
    });
  }
}
