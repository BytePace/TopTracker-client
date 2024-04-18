part of 'project_bloc.dart';

@immutable
sealed class ProjectState extends Equatable {}

final class ProjectInitial extends ProjectState {
  @override
  List<Object?> get props => [];
}

class ProjectListLoading extends ProjectState {
  @override
  List<Object?> get props => [];
}

class ProjectListMessage extends ProjectState {
  final String message;

  ProjectListMessage({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProjectListLoaded extends ProjectState {
  final List<ProjectModel> projects;
  final List<ProfileIdModel> allProfileID;
  final List<UserModel> allUser;

  ProjectListLoaded(
      {required this.projects,
      required this.allProfileID,
      required this.allUser});

  @override
  List<Object?> get props => [projects, allProfileID, allUser];
}
