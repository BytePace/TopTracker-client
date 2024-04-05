import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tt_bytepace/src/features/projects/data/project_repository.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/users/data/user_repository.dart';

part 'detail_project_event.dart';
part 'detail_project_state.dart';

class DetailProjectBloc extends Bloc<DetailProjectEvent, DetailProjectState> {
  final IProjectRepository _projectRepository;
  final IUserRepository _userRepository;

  DetailProjectModel detailProjectModel = const DetailProjectModel(
      users: [],
      invitations: [],
      id: 0,
      name: "",
      engagements: [],
      currentUserRole: "");
  DetailProjectBloc(
      {required IProjectRepository projectRepository,
      required IUserRepository userRepository})
      : _projectRepository = projectRepository,
        _userRepository = userRepository,
        super(ProjectInitial()) {
    on<LoadDetailProjectEvent>(_onLoadProject);
    on<DeleteUserEvent>(_deleteUser);
    on<AddUSerEvent>(_addUser);
    on<RevokeInviteEvent>(_revokeInvite);
  }

  _onLoadProject(
      LoadDetailProjectEvent event, Emitter<DetailProjectState> emit) async {
    emit(DetailProjectListLoading());
    detailProjectModel =
        await _projectRepository.getDetailProject(event.projectID);
    print("      ");
    print(detailProjectModel.engagements);
    print("      ");
    emit(DetailProjectListLoaded(detailProjectModel: detailProjectModel));
  }

  _deleteUser(DeleteUserEvent event, Emitter<DetailProjectState> emit) async {
    await _userRepository.delUser(
        event.projectID, event.profileID, event.context);

    detailProjectModel =
        await _projectRepository.getDetailProject(event.projectID);
    emit(DetailProjectListLoaded(detailProjectModel: detailProjectModel));
  }

  _addUser(AddUSerEvent event, Emitter<DetailProjectState> emit) async {
    await _userRepository.addUser(
        event.email, event.rate, event.role, event.projectID, event.context);

    detailProjectModel =
        await _projectRepository.getDetailProject(event.projectID);
    emit(DetailProjectListLoaded(detailProjectModel: detailProjectModel));
  }

  _revokeInvite(
      RevokeInviteEvent event, Emitter<DetailProjectState> emit) async {
    await _userRepository.revokeInvite(event.invitationsID, event.context);

    detailProjectModel =
        await _projectRepository.getDetailProject(event.projectID);
    emit(DetailProjectListLoaded(detailProjectModel: detailProjectModel));
  }
}
