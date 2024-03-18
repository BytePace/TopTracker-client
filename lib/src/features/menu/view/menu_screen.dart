import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';
import 'package:tt_bytepace/src/features/menu/view/project_screen.dart';
import 'package:tt_bytepace/src/features/menu/view/users_sreen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ProjectService _projectService = ProjectService();
  final UserServices _userServices = UserServices();

  late ProjectsModel _projectsModel =
      ProjectsModel(projects: [], usersOnProject: []);
  late List<ProfileID> _allProfileID = [];
  late List<AllUsers> _allUsers = [];

  Future<void> _fetchData() async {
    try {
      final allProfileID = await _userServices.getAllProfileID();
      final projects = await _projectService.getProjects();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String allUsersString = prefs.getString("allUser") ?? "{}";

      List<AllUsers> list = [];
      json.decode((allUsersString)).forEach((key, value) {
        list.add(AllUsers.fromJson(value));
      });

      if (list.length != allProfileID.length) {
        list = [];
        await _userServices.getAllUsers();
        allUsersString = prefs.getString("allUser") ?? "{}";
        json.decode((allUsersString)).forEach((key, value) {
          list.add(AllUsers.fromJson(value));
        });
      }
      print(list);
      if (mounted) {
        setState(() {
          _projectsModel = projects;
          _allProfileID = allProfileID;
          _allUsers = list;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: const TabBar(
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.black,
            tabs: [
              Tab(icon: Icon(Icons.cases_rounded)),
              Tab(icon: Icon(Icons.bar_chart)),
            ],
          ),
          body: TabBarView(
            children: [
              RefreshIndicator(
                  onRefresh: _fetchData,
                  child: ProjectScreen(
                      projects: _projectsModel, allUsers: _allUsers)),
              UsersScreen(
                  projects: _projectsModel, allProfileID: _allProfileID),
            ],
          ),
        ),
      ),
    );
  }
}
