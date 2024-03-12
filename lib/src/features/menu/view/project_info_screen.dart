import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';

class ProjectInfoScreen extends StatelessWidget {
  final ProjectModel projectModel;
  const ProjectInfoScreen({super.key, required this.projectModel});
  

  @override
  Widget build(BuildContext context) {
    final ProjectService projectService = ProjectService();
    return Scaffold(
      appBar: AppBar(
        title: Text(projectModel.name),
      ),
      body: FutureBuilder(
          future: projectService.getDetailProject(projectModel.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text(snapshot.data!.id.toString()),
                  Text(snapshot.data!.name),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
