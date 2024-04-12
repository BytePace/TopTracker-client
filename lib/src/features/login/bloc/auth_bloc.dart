import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tt_bytepace/src/features/login/data/auth_repository.dart';
import 'package:tt_bytepace/src/features/login/models/login_model.dart';
import 'package:tt_bytepace/src/features/projects/data/project_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;
  final IProjectRepository _projectRepository;
  AuthBloc(
      {required IAuthRepository authRepository,
      required IProjectRepository projectRepository})
      : _authRepository = authRepository,
        _projectRepository = projectRepository,
        super(const LoginInitialState(loginModel: null)) {
    on<LogInEvent>(_login);
    on<LogOutEvent>(_logout);
    on<InitialEvent>(_init);
  }
  LoginModel loginModel =
      const LoginModel(id: 0, username: "", email: "", accessToken: "");

  Future<void> _login(LogInEvent event, Emitter<AuthState> emit) async {
    try {
      loginModel = await _authRepository.doLogin(event.email, event.password);
      emit(const LoginMessageState(message: 'Успешный вход'));
      emit(SignInState());
    } catch (e) {
      emit(const LoginMessageState(message: "Неправильный логин или пароль"));
      emit(const IsLoginState());
    }
  }

  Future<void> _logout(LogOutEvent event, Emitter<AuthState> emit) async {
    try {
      await _projectRepository.dropDB();
      await _authRepository.doLogout();
      emit(const IsLoginState());
    } catch (e) {
      emit(LoginMessageState(message: e.toString()));
      emit(const IsLoginState());
    }
  }

  void _init(InitialEvent event, Emitter<AuthState> emit) async {
    if (await _authRepository.getToken() == null) {
      emit(const IsLoginState());
    } else {
      emit(SignInState());
    }
  }
}
