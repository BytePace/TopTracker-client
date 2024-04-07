class LoginDto {
  final int id;
  final String username;
  final String email;
  final String access_token;

  const LoginDto(
      {required this.id,
      required this.username,
      required this.email,
      required this.access_token});

  factory LoginDto.fromJson(Map<String, dynamic> json) {
    return LoginDto(
        id: json['user']['id'].toInt(),
        username: json['user']['name'],
        email: json['user']['email'],
        access_token: json['access_token']);
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          email == other.email &&
          access_token == other.access_token;

  @override
  int get hashCode =>
      id.hashCode ^ username.hashCode ^ email.hashCode ^ access_token.hashCode;
}
