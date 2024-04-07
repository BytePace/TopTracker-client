part of 'project_bloc.dart';

@immutable
sealed class ProjectState {}

final class ProjectInitial extends ProjectState {}

class ProjectListLoading extends ProjectState {}

class ProjectListLoaded extends ProjectState {
  final List<ProjectModel> projects;
  final List<ProfileIdModel> allProfileID;
  final List<UserModel> allUser;

  ProjectListLoaded(
      {required this.projects,
      required this.allProfileID,
      required this.allUser});
}
