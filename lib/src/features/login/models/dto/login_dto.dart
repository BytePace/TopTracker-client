
class LoginDto {
  final int id;
  final String username;
  final String email;
  final String accessToken;

  const LoginDto(
      {required this.id,
      required this.username,
      required this.email,
      required this.accessToken});

  factory LoginDto.fromJson(Map<String, dynamic> json) {
    return LoginDto(
        id: json[_JsonKey.user][_JsonKey.loginID].toInt(),
        username: json[_JsonKey.user][_JsonKey.name],
        email: json[_JsonKey.user][_JsonKey.email],
        accessToken: json[_JsonKey.accessToken]);
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          email == other.email &&
          accessToken == other.accessToken;

  @override
  int get hashCode =>
      id.hashCode ^ username.hashCode ^ email.hashCode ^ accessToken.hashCode;
}

class _JsonKey {
  static const user = "user";
  static const loginID = "id";
  static const name = "name";
  static const accessToken = "access_token";
  static const email = "email";
}
