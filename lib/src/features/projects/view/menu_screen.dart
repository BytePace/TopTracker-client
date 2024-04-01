import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/features/archived_projects/view/archived_project_screen.dart';
import 'package:tt_bytepace/src/features/projects/bloc/detail_project_bloc/detail_project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/bloc/project_bloc/project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/data/data_sources/project_data_source.dart';
import 'package:tt_bytepace/src/features/projects/data/project_repository.dart';
import 'package:tt_bytepace/src/features/projects/view/project_screen.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/app_bar.dart';
import 'package:tt_bytepace/src/features/users/data/data_sources/user_data_source.dart';
import 'package:tt_bytepace/src/features/users/data/user_repository.dart';
import 'package:tt_bytepace/src/features/users/view/users_sreen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentTub = 0;

  final ProjectBloc projectListBloc = GetIt.I<ProjectBloc>();

  @override
  void initState() {
    super.initState();
    projectListBloc.add(LoadProjectEvent());
  }

  Future<void> fetchUpdate() async {
    await Future.delayed(const Duration(seconds: 2));
    projectListBloc.add(LoadProjectEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const MyAppBar(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: fetchUpdate,
            child: BlocBuilder<ProjectBloc, ProjectState>(
                bloc: projectListBloc,
                builder: (context, state) {
                  if (state is ProjectListLoaded) {
                    return [
                      ProjectScreen(
                          key: UniqueKey(),
                          projects: state.projects
                              .where((element) => element.archivedAt == null)
                              .toList(),
                          allUsers: state.allUser),
                      ArchivedProjectScreen(
                          key: UniqueKey(),
                          projects: state.projects
                              .where((element) => element.archivedAt != null)
                              .toList(),
                          allProfileID: state.allProfileID),
                      UsersScreen(
                          key: UniqueKey(),
                          projects: state.projects,
                          allProfileID: state.allProfileID),
                    ][_currentTub];
                  } else {
                    return const Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Введите название проекта',
                          ),
                        ),
                        SizedBox(height: 220),
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  }
                }),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.cases_rounded),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.badge_rounded),
              label: 'Archived Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Users',
            )
          ],
          currentIndex: _currentTub,
          selectedItemColor: Colors.amber[800],
          onTap: (value) {
            setState(() {
              _currentTub = value;
            });
          },
        ),
      ),
    );
  }
}
