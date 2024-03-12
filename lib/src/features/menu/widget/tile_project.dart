import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';

class ProjectTile extends StatelessWidget {
  final Function() onTap;
  final ProjectModel projectModel;
  const ProjectTile(
      {super.key, required this.onTap, required this.projectModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        title: Text(projectModel.name),
      ),
    );
  }
}
