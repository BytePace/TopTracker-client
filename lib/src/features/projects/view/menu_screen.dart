import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/features/archived_projects/view/archived_project_screen.dart';
import 'package:tt_bytepace/src/features/projects/bloc/project_bloc/project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/features/projects/view/project_screen.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/app_bar.dart';
import 'package:tt_bytepace/src/features/users/view/users_sreen.dart';
import 'package:tt_bytepace/src/resources/colors.dart';
import 'package:tt_bytepace/src/resources/text.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<ProjectModel> _projects = [];
  int _currentTub = 0;

  final ProjectBloc projectListBloc = GetIt.I<ProjectBloc>();

  @override
  void initState() {
    super.initState();
    projectListBloc.add(LoadProjectEvent());
  }

  Future<void> _fetchUpdate() async {
    projectListBloc.add(UpdateProjectEvent(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyAppBar(currentTub: _currentTub, projects: _projects),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: _fetchUpdate,
          child: BlocConsumer<ProjectBloc, ProjectState>(
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
                      allUser: state.allUser),
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
                        hintText: CustomText.hintSearchProjectText,
                      ),
                    ),
                    SizedBox(height: 220),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              }
            },
            listener: (BuildContext context, ProjectState state) {
              if (state is ProjectListLoaded) {
                setState(() {
                  _projects = state.projects;
                });
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.cases_rounded),
            label: CustomText.bottomBarProjects,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.badge_rounded),
            label: CustomText.bottomBarArchivedProjects,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: CustomText.bottomBarUsers,
          )
        ],
        currentIndex: _currentTub,
        selectedItemColor: CustomColors.bottomActiveIconColor,
        onTap: (value) {
          setState(() {
            _currentTub = value;
          });
        },
      ),
    );
  }
}
