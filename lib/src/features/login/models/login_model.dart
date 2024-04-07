import 'package:tt_bytepace/src/features/login/models/dto/login_dto.dart';

class LoginModel {
  final int id;
  final String username;
  final String email;
  final String access_token;

  const LoginModel(
      {required this.id,
      required this.username,
      required this.email,
      required this.access_token});

  factory LoginModel.fromDto(LoginDto dto) {
    return LoginModel(
      id: dto.id,
      username: dto.username,
      email: dto.email,
      access_token: dto.access_token,
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          email == other.email &&
          access_token == other.access_token;

  @override
  int get hashCode =>
      id.hashCode ^ username.hashCode ^ email.hashCode ^ access_token.hashCode;
}
