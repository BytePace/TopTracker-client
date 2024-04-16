
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:tt_bytepace/src/features/archived_projects/view/archived_project_info_srceen.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/tile_project.dart';
import 'package:tt_bytepace/src/resources/text.dart';

class ArchivedProjectScreen extends StatefulWidget {
  final List<ProjectModel> projects;
  final List<UserModel> allUser;
  const ArchivedProjectScreen(
      {super.key, required this.projects, required this.allUser});

  @override
  State<ArchivedProjectScreen> createState() => _ArchivedProjectScreenState();
}

class _ArchivedProjectScreenState extends State<ArchivedProjectScreen> {
  late List<ProjectModel> projects;
  bool isAsc = true;

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
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: DisplayText.hintSearchProjectText,
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
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      isAsc
                          ? projects.sort((a, b) => a.name.compareTo(b.name))
                          : projects.sort((a, b) => b.name.compareTo(a.name));
                      isAsc = !isAsc;
                    });
                  },
                  icon: isAsc
                      ? const Icon(Icons.arrow_downward)
                      : const Icon(Icons.arrow_upward))
            ],
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
                          builder: (context) => BlocProvider<DetailProjectBloc>(
                            create: (context) => GetIt.I<DetailProjectBloc>(),
                            child: ArchivedProjectInfoScreen(
                              id: projects[index].id,
                              name: projects[index].name,
                              allUsers: widget.allUser,
                              project: projects[index],
                            ),
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
