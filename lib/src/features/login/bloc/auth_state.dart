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

class SignInState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoginMessageState extends AuthState {
  final String message;

  const LoginMessageState({super.loginModel, required this.message});

  @override
  List<Object?> get props => [message];
}

class IsLoginState extends AuthState {
  const IsLoginState({super.loginModel});
  @override
  List<Object?> get props => [];
}
