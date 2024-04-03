import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/data/data_sources/project_data_source.dart';
import 'package:tt_bytepace/src/features/projects/data/data_sources/savable_project_data_source.dart';
import 'package:tt_bytepace/src/features/projects/data/project_repository.dart';
import 'package:tt_bytepace/src/features/projects/model/detail_project_model.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';

import 'package:tt_bytepace/src/features/projects/view/project_info_screen.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/tile_project.dart';
import 'package:tt_bytepace/src/features/users/data/data_sources/user_data_source.dart';
import 'package:tt_bytepace/src/resources/text.dart';

import '../../users/data/user_repository.dart';

class ProjectScreen extends StatefulWidget {
  final List<ProjectModel> projects;
  final List<UserModel> allUsers;
  const ProjectScreen(
      {super.key, required this.projects, required this.allUsers});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  bool isAsc = true;
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
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: CustomText.hintSearchProjectText,
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
                            builder: (context) =>
                                BlocProvider<DetailProjectBloc>(
                              create: (context) => DetailProjectBloc(
                                projectRepository: ProjectRepository(
                                  networkProjectDataSource:
                                      NetworkProjectDataSource(
                                          dio: Dio(BaseOptions(
                                              baseUrl:
                                                  "https://tracker-api.toptal.com"))),
                                  //dbProjectDataSource: DbProjectDataSource(
                                     // database: GetIt.I<Database>()),
                                ),
                                userRepository: UserRepository(
                                  networkUserDataSource: NetworkUserDataSource(
                                      dio: Dio(BaseOptions(
                                          baseUrl:
                                              "https://tracker-api.toptal.com"))),
                                ),
                              ),
                              child: ProjectInfoScreen(
                                id: projects[index].id,
                                name: projects[index].name,
                                allUsers: widget.allUsers,
                              ),
                            ),
                          ));
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
