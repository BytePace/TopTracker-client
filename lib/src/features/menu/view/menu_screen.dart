import 'package:flutter/material.dart';
import 'package:tt_bytepace/src/features/menu/models/project_model.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';
import 'package:tt_bytepace/src/features/menu/view/project_screen.dart';
import 'package:tt_bytepace/src/features/menu/view/users_sreen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ProjectService _projectService = ProjectService();
  late ProjectsModel _projectsModel = ProjectsModel(projects: [], allUsers: []);

  Future<void> _fetchProjects() async {
    try {
      final projects = await _projectService.getProjects();
      if (mounted) {
        setState(() {
          _projectsModel = projects;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProjects();
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
                  onRefresh: _fetchProjects,
                  child: ProjectScreen(projects: _projectsModel)),
              const UsersScreen(),
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   body: [
    //     ProjectScreen(projects: _projectsModel),
    //     const UsersScreen(),
    //   ][_selectedIndex],
    //   bottomNavigationBar: BottomNavigationBar(
    //     items: const <BottomNavigationBarItem>[
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.cases_rounded),
    //         label: 'Projects',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.bar_chart),
    //         label: 'Users',
    //       )
    //     ],
    //     currentIndex: _selectedIndex,
    //     selectedItemColor: Colors.amber[800],
    //     onTap: _onItemTapped,
    //   ),
    // );
  }
}
