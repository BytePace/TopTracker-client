part of 'project_bloc.dart';

@immutable
sealed class ProjectEvent {}

class LoadProjectEvent extends ProjectEvent {}

class RestoreProjectEvent extends ProjectEvent {
  final int id;

  RestoreProjectEvent({required this.id});
}

class DeleteProjectEvent extends ProjectEvent {
  final int id;

  DeleteProjectEvent({required this.id});
}
