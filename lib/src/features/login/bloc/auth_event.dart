part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {}

class LogInEvent extends AuthEvent {
  final String email;
  final String password;

  LogInEvent(
      {required this.email, required this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [email, password];
}

class LogOutEvent extends AuthEvent {

  LogOutEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitialEvent extends AuthEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
