class DetailProjectModel {
  final int id;
  final String name;

  const DetailProjectModel({
    required this.id,
    required this.name
  });

  factory DetailProjectModel.fromJson(Map<String, dynamic> json) {
    return DetailProjectModel(
      id: json['project']['id'].toInt(),
      name: json['project']['name']
    );
  }
}