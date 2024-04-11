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
        id: json['user']['id'].toInt(),
        username: json['user']['name'],
        email: json['user']['email'],
        accessToken: json['access_token']);
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
