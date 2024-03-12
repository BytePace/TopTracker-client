import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/login/widget/button.dart';
import 'package:tt_bytepace/src/features/menu/view/project_screen.dart';
import 'package:tt_bytepace/src/features/menu/view/users_sreen.dart';
import 'package:tt_bytepace/src/features/login/services/auth_services.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(builder: (context, authState, _) {
      return Scaffold(
        body: [
          const ProjectScreen(),
          const UsersScreen(),
        ][_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Users',
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      );
    });
  }
}
