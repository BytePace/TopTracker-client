part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  final LoginModel? loginModel;

  const AuthState({this.loginModel});
  @override
  List<Object?> get props => [loginModel];
}

class LoginInitialState extends AuthState {
  const LoginInitialState({required super.loginModel});

  @override
  List<Object?> get props => [];
}

class LoginSuccessState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoginErrorState extends AuthState {
  final String error;

  const LoginErrorState({super.loginModel, required this.error});

  @override
  List<Object?> get props => [error];
}

class IsLoginState extends AuthState {
  @override
  List<Object?> get props => [];
}
