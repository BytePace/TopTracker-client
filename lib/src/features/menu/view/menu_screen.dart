import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/login/services/auth_service.dart';
import 'package:tt_bytepace/src/features/menu/bloc/ProjectListBloc/project_list_bloc.dart';

import 'package:tt_bytepace/src/features/menu/view/archived_project_screen.dart';
import 'package:tt_bytepace/src/features/menu/view/project_screen.dart';
import 'package:tt_bytepace/src/features/users/view/users_sreen.dart';
import 'package:tt_bytepace/src/features/menu/view/widget/alert_dialog.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentTub = 0;

  final ProjectListBloc projectListBloc = GetIt.I<ProjectListBloc>();

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
    final viewModel = Provider.of<AuthService>(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  key: const Key("appbar"),
                  _currentTub == 0
                      ? "Projects"
                      : _currentTub == 1
                          ? "Archived Projects"
                          : "Users"),
              TextButton(
                child: const Text("logout"),
                onPressed: () => showDialog<void>(
                    context: context,
                    builder: (ctx) => MyAlertDialog(
                          ctx: context,
                          title: "Log Out",
                          content: "Are you sure want to log out?",
                          isYes: TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                viewModel.logout();
                              },
                              child: const Text(
                                "Log Out",
                                style: TextStyle(color: Colors.black),
                              )),
                        )),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: fetchUpdate,
            child: BlocBuilder<ProjectListBloc, ProjectListState>(
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
