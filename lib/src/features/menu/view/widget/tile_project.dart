import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';

class ProjectTile extends StatelessWidget {
  final Function() onTap;
  final ProjectModel projectModel;
  const ProjectTile(
      {super.key, required this.onTap, required this.projectModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        title: Text(projectModel.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("created at: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(projectModel.createdAt))}"),
            Text("admin: ${projectModel.adminName}"),
          ],
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        trailing: const Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}
