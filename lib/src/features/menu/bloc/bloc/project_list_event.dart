part of 'project_list_bloc.dart';

@immutable
sealed class ProjectListEvent {}

class LoadProjectEvent extends ProjectListEvent {
  final ProjectService projectService;
  final UserServices userServices;

  LoadProjectEvent({required this.projectService, required this.userServices});
}
