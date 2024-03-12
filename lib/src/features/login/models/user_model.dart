class UserModel {
  final int id;
  final String username;
  final String email;
  final String access_token;

  const UserModel(
      {required this.id,
      required this.username,
      required this.email,
      required this.access_token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['user']['id'].toInt(),
        username: json['user']['name'],
        email: json['user']['email'],
        access_token: json['access_token']);
  }
}
