import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';
import 'package:tt_bytepace/src/features/menu/view/project_info_screen.dart';
import 'package:tt_bytepace/src/features/menu/widget/tile_project.dart';

class ProjectScreen extends StatefulWidget {
  final ProjectsModel projects;
  const ProjectScreen({super.key, required this.projects});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView.builder(
        itemCount: widget.projects.projects.length,
        itemBuilder: (BuildContext context, int index) {
          return ProjectTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectInfoScreen(
                      id: widget.projects.projects[index].id,
                      name: widget.projects.projects[index].name,
                      allUsers: widget.projects.usersOnProject,
                    ),
                  ),
                );
              },
              projectModel: widget.projects.projects[index]);
        },
      ),
    );
  }
}
