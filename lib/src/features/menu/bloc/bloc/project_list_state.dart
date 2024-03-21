part of 'project_list_bloc.dart';

@immutable
sealed class ProjectListState {}

final class ProjectListInitial extends ProjectListState {}

class ProjectListLoading extends ProjectListState {}

class ProjectListLoaded extends ProjectListState {
  final List<ProjectModel> projects;
  final List<ProfileID> allProfileID;
  final List<UserModel> allUser;

  ProjectListLoaded(
      {required this.projects,
      required this.allProfileID,
      required this.allUser});
}

class ProjectListWithUserLoad extends ProjectListState {
  final List<ProjectModel> projects;
  final List<ProfileID> allProfileID;
  final List<UserModel> allUser;

  ProjectListWithUserLoad(
      {required this.allUser,
      required this.allProfileID,
      required this.projects});
}
