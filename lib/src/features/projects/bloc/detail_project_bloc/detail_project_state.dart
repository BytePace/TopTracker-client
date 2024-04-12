part of 'detail_project_bloc.dart';

@immutable
sealed class DetailProjectState extends Equatable {}

final class DetailProjectInitial extends DetailProjectState {
  @override
  List<Object?> get props => [];
}

class DetailProjectListLoading extends DetailProjectState {
  @override
  List<Object?> get props => [];
}

class DetailProjectListLoaded extends DetailProjectState {
  final DetailProjectModel detailProjectModel;

  DetailProjectListLoaded({required this.detailProjectModel});
  
  @override

  List<Object?> get props => [detailProjectModel];
}

class DetailProjectListMessage extends DetailProjectState {
  final String message;

  DetailProjectListMessage({required this.message});
  
  @override
  List<Object?> get props => [message];
}
