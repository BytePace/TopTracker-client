import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/login/services/auth_service.dart';
import 'package:tt_bytepace/src/features/menu/models/all_users_model.dart';
import 'package:tt_bytepace/src/features/menu/models/detail_project_model.dart';
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
  int _currentTub = 0;
  final ProjectService _projectService = ProjectService();
  final UserServices _userServices = UserServices();

  late List<ProjectModel> _projects = [];
  late List<ProfileID> _allProfileID = [];
  late List<UserModel> _allUsers = [];

  Future<List<UserModel>> _getAllUsers(List<ProfileID> allProfileID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String allUsersString = prefs.getString("allUser") ?? "{}";

    List<UserModel> list = [];
    json.decode((allUsersString)).forEach((key, value) {
      list.add(UserModel.fromJson(value));
    });

    final countUser = prefs.getInt("countUser") ?? 0;

    print("${countUser}   ${allProfileID.length}");

    if (countUser != allProfileID.length) {
      prefs.setInt("countUser", allProfileID.length);
      list = [];
      await _userServices.getAllUsers();
      allUsersString = prefs.getString("allUser") ?? "{}";
      json.decode((allUsersString)).forEach((key, value) {
        list.add(UserModel.fromJson(value));
      });
    }
    return list;
  }

  Future<void> _fetchData() async {
    try {
      final allProfileID = await _userServices.getAllProfileID();
      final projects = await _projectService.getProjects();
      final allUsers = await _getAllUsers(allProfileID);
      if (mounted) {
        setState(() {
          _projects = projects;
          _allProfileID = allProfileID;
          _allUsers = allUsers;
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
    final viewModel = Provider.of<AuthService>(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_currentTub == 0 ? "Projects" : "Users"),
              TextButton(
                child: const Text("logout"),
                onPressed: () {
                  viewModel.logout();
                },
              ),
            ],
          ),
        ),
        body: _projects.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: [
                  RefreshIndicator(
                      onRefresh: _fetchData,
                      child: ProjectScreen(
                          projects: _projects, allUsers: _allUsers)),
                  UsersScreen(projects: _projects, allProfileID: _allProfileID),
                ][_currentTub],
              ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.cases_rounded),
              label: 'Projects',
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
