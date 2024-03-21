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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.projects.length,
        itemBuilder: (BuildContext context, int index) {
          return ProjectTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArchivedProjectInfoScreen(
                      id: widget.projects[index].id,
                      name: widget.projects[index].name,
                      allUsers: widget.allProfileID,
                    ),
                  ),
                );
              },
              projectModel: widget.projects[index]);
        },
      ),
    );
  }
}
