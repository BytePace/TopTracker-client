part of 'project_list_bloc.dart';

@immutable
abstract class ProjectListState {
  final List<ProjectModel> projects;
  final List<ProfileID> allProfileID;
  final List<UserModel> allUser;

  const ProjectListState(
      {required this.projects,
      required this.allProfileID,
      required this.allUser});
}

final class ProjectListInitial extends ProjectListState {
  const ProjectListInitial({required super.projects, required super.allProfileID, required super.allUser});
}

class ProjectListLoading extends ProjectListState {
  const ProjectListLoading({required super.projects, required super.allProfileID, required super.allUser});
}

class ProjectListLoaded extends ProjectListState {
  const ProjectListLoaded({required super.projects, required super.allProfileID, required super.allUser});

}

class ProjectListWithUserLoad extends ProjectListState {
  const ProjectListWithUserLoad({required super.projects, required super.allProfileID, required super.allUser});

}
