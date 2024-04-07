part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  final LoginModel? loginModel;

  const AuthState({this.loginModel});
}

class LoginInitialState extends AuthState {
  const LoginInitialState({required super.loginModel});
}

class LoginSuccessState extends AuthState {}

class LoginErrorState extends AuthState {
  final String error;

  const LoginErrorState({super.loginModel, required this.error});
}

class IsLoginState extends AuthState {}
