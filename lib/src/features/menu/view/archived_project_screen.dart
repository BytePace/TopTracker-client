import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/menu/view/archived_project_info_srceen.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/tile_project.dart';

class ArchivedProjectScreen extends StatefulWidget {
  final List<ProjectModel> projects;
  final List<ProfileID> allProfileID;
  const ArchivedProjectScreen(
      {super.key, required this.projects, required this.allProfileID});

  @override
  State<ArchivedProjectScreen> createState() => _ArchivedProjectScreenState();
}

class _ArchivedProjectScreenState extends State<ArchivedProjectScreen> {
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
            decoration: const InputDecoration(
              hintText: 'Введите название проекта',
            ),
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
          Expanded(
            child: ListView.builder(
              itemCount: projects.length,
              itemBuilder: (BuildContext context, int index) {
                return ProjectTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArchivedProjectInfoScreen(
                            id: projects[index].id,
                            name: projects[index].name,
                            allUsers: widget.allProfileID,
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
