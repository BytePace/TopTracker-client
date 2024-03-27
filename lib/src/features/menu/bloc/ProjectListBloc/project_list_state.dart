part of 'project_list_bloc.dart';

@immutable
abstract class ProjectListState {}

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

class ProjectListUpdate extends ProjectListState {
  final List<ProjectModel> projects;
  final List<ProfileID> allProfileID;
  final List<UserModel> allUser;

  ProjectListUpdate(
      {required this.projects,
      required this.allProfileID,
      required this.allUser});
}
