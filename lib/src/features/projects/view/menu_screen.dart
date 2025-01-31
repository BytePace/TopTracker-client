import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/features/archived_projects/view/archived_project_screen.dart';
import 'package:tt_bytepace/src/features/projects/bloc/project_bloc/project_bloc.dart';
import 'package:tt_bytepace/src/features/projects/model/project_model.dart';
import 'package:tt_bytepace/src/features/projects/view/project_screen.dart';
import 'package:tt_bytepace/src/features/projects/view/widget/app_bar.dart';
import 'package:tt_bytepace/src/features/users/view/users_sreen.dart';
import 'package:tt_bytepace/src/features/utils/methods.dart';
import 'package:tt_bytepace/src/resources/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    projectListBloc.add(UpdateProjectEvent());
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
                List<ProjectModel> projectList = state.projects;
                projectList.sort((a, b) => a.name.compareTo(b.name));
                return [
                  ProjectScreen(
                      key: UniqueKey(),
                      projects: projectList
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
                return Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.hintSearchProjectText,
                      ),
                    ),
                    const SizedBox(height: 220),
                    const Center(child: CircularProgressIndicator()),
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
              if (state is ProjectListMessage) {
                switch (state.message) {
                  case "noInternet":
                    showSnackBar(
                        context, AppLocalizations.of(context)!.noInternet);
                  case "dearchiveSuccess":
                    showSnackBar(context,
                        AppLocalizations.of(context)!.dearchiveSuccess);
                  case "error":
                    showSnackBar(
                        context, AppLocalizations.of(context)!.noInternet);
                  case "deleteProjectSuccess":
                    showSnackBar(context,
                        AppLocalizations.of(context)!.deleteProjectSuccess);
                  case "archiveSuccess":
                    showSnackBar(
                        context, AppLocalizations.of(context)!.archiveSuccess);
                  default:
                    showSnackBar(
                        context, AppLocalizations.of(context)!.noInternet);
                }
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.cases_rounded),
            label: AppLocalizations.of(context)!.bottomBarProjects,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.badge_rounded),
            label: AppLocalizations.of(context)!.bottomBarArchivedProjects,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart),
            label: AppLocalizations.of(context)!.bottomBarUsers,
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
