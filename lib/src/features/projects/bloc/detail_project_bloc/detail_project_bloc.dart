import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tt_bytepace/src/features/projects/data/project_repository.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/users/data/user_repository.dart';
import 'package:tt_bytepace/src/features/utils/methods.dart';

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
    emit(DetailProjectListLoaded(detailProjectModel: detailProjectModel));
  }

  _deleteUser(DeleteUserEvent event, Emitter<DetailProjectState> emit) async {
    try {
      await _userRepository.delUser(event.projectID, event.profileID);

      detailProjectModel =
          await _projectRepository.getDetailProject(event.projectID);
      emit(DetailProjectListLoaded(detailProjectModel: detailProjectModel));
      showCnackBar(event.context, "Пользователь удален");
    } catch (e) {
      print("ошибка добавления пользователя $e");
      showCnackBar(event.context, "Произошла ошибка ");
    }
  }

  _addUser(AddUSerEvent event, Emitter<DetailProjectState> emit) async {
    try {
      await _userRepository.addUser(
          event.email, event.rate, event.role, event.projectID);

      detailProjectModel =
          await _projectRepository.getDetailProject(event.projectID);
      emit(DetailProjectListLoaded(detailProjectModel: detailProjectModel));
      showCnackBar(event.context, "Пользователь добавлен");
    } catch (e) {
      print("ошибка удаления пользователя $e");
      showCnackBar(event.context, "Произошла ошибка $e");
    }
  }

  _revokeInvite(
      RevokeInviteEvent event, Emitter<DetailProjectState> emit) async {
    try {
      await _userRepository.revokeInvite(event.invitationsID);

      detailProjectModel =
          await _projectRepository.getDetailProject(event.projectID);
      emit(DetailProjectListLoaded(detailProjectModel: detailProjectModel));

      showCnackBar(event.context, "Приглашение отменено");
    } catch (e) {
      print("произошла отмены приглашения ошибка $e");
      showCnackBar(event.context, "Произошла ошибка");
    }
  }
}
