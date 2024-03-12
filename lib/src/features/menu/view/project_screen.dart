import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';
import 'package:tt_bytepace/src/features/menu/view/project_info_screen.dart';
import 'package:tt_bytepace/src/features/menu/widget/tile_project.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final ProjectService _projectService = ProjectService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _projectService.getProjects(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.projects.length,
              itemBuilder: (BuildContext context, int index) {
                return ProjectTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectInfoScreen(projectModel: snapshot.data!.projects[index]),
                        ),
                      );
                    },
                    projectModel: snapshot.data!.projects[index]);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
