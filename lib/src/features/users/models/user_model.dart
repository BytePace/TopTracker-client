class UserModel {
  final int id;
  final String name;

  const UserModel({
    required this.id,
    required this.name
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['project']['id'].toInt(),
      name: json['project']['name']
    );
  }
}