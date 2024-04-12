part of 'project_bloc.dart';

@immutable
sealed class ProjectEvent {}

class LoadProjectEvent extends ProjectEvent {}

class RestoreProjectEvent extends ProjectEvent {
  final int id;
  final BuildContext context;

  RestoreProjectEvent({required this.id, required this.context});
}

class DeleteProjectEvent extends ProjectEvent {
  final int id;
  final BuildContext context;

  DeleteProjectEvent({required this.id, required this.context});
}
class ArchiveProjectEvent extends ProjectEvent {
  final int id;
  final BuildContext context;

  ArchiveProjectEvent({required this.id, required this.context});
}



class UpdateProjectEvent extends ProjectEvent {
  final BuildContext context;

  UpdateProjectEvent({required this.context});
}
