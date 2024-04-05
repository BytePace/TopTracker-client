part of 'detail_project_bloc.dart';

@immutable
sealed class DetailProjectState {}

final class ProjectInitial extends DetailProjectState {}

class DetailProjectListLoading extends DetailProjectState {}

class DetailProjectListLoaded extends DetailProjectState {
  final DetailProjectModel detailProjectModel;

  DetailProjectListLoaded({required this.detailProjectModel});

 
}
