part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {}

class LogInEvent extends AuthEvent {
  final String email;
  final String password;
  final BuildContext context;

  LogInEvent(
      {required this.email, required this.password, required this.context});

  @override
  // TODO: implement props
  List<Object?> get props => [email, password, context];
}

class LogOutEvent extends AuthEvent {
  final BuildContext context;

  LogOutEvent({required this.context});

  @override
  // TODO: implement props
  List<Object?> get props => [context];
}

class InitialEvent extends AuthEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
