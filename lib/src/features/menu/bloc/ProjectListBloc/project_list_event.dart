part of 'project_list_bloc.dart';

@immutable
sealed class ProjectListEvent {}

class LoadProjectEvent extends ProjectListEvent {}

class RestoreProjectEvent extends ProjectListEvent {
  final int id;

  RestoreProjectEvent({required this.id});
}

class DeleteProjectEvent extends ProjectListEvent {
    final int id;

  DeleteProjectEvent({required this.id});
}
