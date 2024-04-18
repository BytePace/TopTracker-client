import 'package:tt_bytepace/src/features/login/models/dto/login_dto.dart';

class LoginModel {
  final int id;
  final String username;
  final String email;
  final String accessToken;

  const LoginModel(
      {required this.id,
      required this.username,
      required this.email,
      required this.accessToken});

  factory LoginModel.fromDto(LoginDto dto) {
    return LoginModel(
      id: dto.id,
      username: dto.username,
      email: dto.email,
      accessToken: dto.accessToken,
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
          accessToken == other.accessToken;

  @override
  int get hashCode =>
      id.hashCode ^ username.hashCode ^ email.hashCode ^ accessToken.hashCode;
}
