import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/menu/view/project_info_screen.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/tile_project.dart';

class ProjectScreen extends StatefulWidget {
  final List<ProjectModel> projects;
  final List<UserModel> allUsers;
  const ProjectScreen(
      {super.key, required this.projects, required this.allUsers});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  late List<ProjectModel> projects;
  @override
  void initState() {
    super.initState();
    projects = widget.projects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                projects = widget.projects
                    .where((element) => element.name
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
              });
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: projects.length,
              itemBuilder: (BuildContext context, int index) {
                return ProjectTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectInfoScreen(
                            id: projects[index].id,
                            name: projects[index].name,
                            allUsers: widget.allUsers,
                          ),
                        ),
                      );
                    },
                    projectModel: projects[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
