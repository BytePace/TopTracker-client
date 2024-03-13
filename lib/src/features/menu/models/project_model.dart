class ProjectsModel {
  final List<ProjectModel> projects;

  ProjectsModel({required this.projects});

  factory ProjectsModel.fromJson(Map<String, dynamic> json) {
    final List<ProjectModel> projects = [];
    json["projects"]
        .forEach((json) => {projects.add(ProjectModel.fromJson(json))});

    return ProjectsModel(projects: projects);
  }
}

class ProjectModel {
  final int id;
  final String name;

  const ProjectModel({
    required this.id,
    required this.name,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'].toInt(),
      name: json['name']
    );
  }
}

