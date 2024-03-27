part of 'project_list_bloc.dart';

@immutable
sealed class ProjectListEvent {}

class LoadProjectEvent extends ProjectListEvent {}


class UpdateProjectEvent extends ProjectListEvent {

}
