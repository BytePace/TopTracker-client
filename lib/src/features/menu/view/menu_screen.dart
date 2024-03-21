import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/login/services/auth_service.dart';
import 'package:tt_bytepace/src/features/menu/bloc/bloc/project_list_bloc.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';
import 'package:tt_bytepace/src/features/menu/view/archived_project_screen.dart';
import 'package:tt_bytepace/src/features/menu/view/project_screen.dart';
import 'package:tt_bytepace/src/features/menu/view/users_sreen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentTub = 0;
  final ProjectService _projectService = ProjectService();
  final UserServices _userServices = UserServices();

  final ProjectListBloc projectListBloc = ProjectListBloc();

  @override
  void initState() {
    super.initState();
    projectListBloc.add(LoadProjectEvent(
        projectService: _projectService, userServices: _userServices));
  }

  void _fetchData() async {
    projectListBloc.add(LoadProjectEvent(
        projectService: _projectService, userServices: _userServices));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthService>(context);
    return MaterialApp(
      home: BlocProvider(
        create: (context) => projectListBloc,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_currentTub == 0
                    ? "Projects"
                    : _currentTub == 1
                        ? "ArchivedProjects"
                        : "Users"),
                TextButton(
                  child: const Text("logout"),
                  onPressed: () {
                    viewModel.logout();
                  },
                ),
              ],
            ),
          ),
          body: BlocBuilder<ProjectListBloc, ProjectListState>(
              bloc: projectListBloc,
              builder: (context, state) {
                if (state is ProjectListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProjectListLoaded) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: [
                      RefreshIndicator(
                          onRefresh: () async {
                            _fetchData;
                          },
                          child: ProjectScreen(
                              projects: state.projects
                                  .where(
                                      (element) => element.archivedAt == null)
                                  .toList(),
                              allUsers: state.allUser)),
                      RefreshIndicator(
                          onRefresh: () async {
                            _fetchData;
                          },
                          child: ArchivedProjectScreen(
                              projects: state.projects
                                  .where(
                                      (element) => element.archivedAt != null)
                                  .toList(),
                              allProfileID: state.allProfileID)),
                      UsersScreen(
                          projects: state.projects,
                          allProfileID: state.allProfileID),
                    ][_currentTub],
                  );
                } else if (state is ProjectListWithUserLoad) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: [
                      RefreshIndicator(
                          onRefresh: () async {_fetchData;},
                          child: ProjectScreen(
                              projects: state.projects
                                  .where(
                                      (element) => element.archivedAt == null)
                                  .toList(),
                              allUsers: state.allUser)),
                      RefreshIndicator(
                          onRefresh: () async {_fetchData;},
                          child: ArchivedProjectScreen(
                              projects: state.projects
                                  .where(
                                      (element) => element.archivedAt != null)
                                  .toList(),
                              allProfileID: state.allProfileID)),
                      UsersScreen(
                          projects: state.projects,
                          allProfileID: state.allProfileID),
                    ][_currentTub],
                  );
                } else {
                  return const Center(child: Text("Ошибка"));
                }
              }),
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
      ),
    );
  }
}
