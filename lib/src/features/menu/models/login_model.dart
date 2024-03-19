class LoginModel {
  final int id;
  final String name;

  const LoginModel({
    required this.id,
    required this.name
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['project']['id'].toInt(),
      name: json['project']['name']
    );
  }
}