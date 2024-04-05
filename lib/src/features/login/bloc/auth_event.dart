part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LogInEvent extends AuthEvent {
  final String email;
  final String password;
  final BuildContext context;

  LogInEvent(
      {required this.email, required this.password, required this.context});
}

class LogOutEvent extends AuthEvent {
  final BuildContext context;

  LogOutEvent({required this.context});
}

class InitialEvent extends AuthEvent {}
