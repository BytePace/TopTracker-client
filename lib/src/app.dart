import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/login/view/login_screen.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';
import 'package:tt_bytepace/src/features/menu/view/menu_screen.dart';
import 'package:tt_bytepace/src/features/login/services/auth_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ProjectService()),
        ChangeNotifierProvider(create: (context) => UserServices()),
      ],
      builder: (context, child) => Scaffold(
        body: Consumer<AuthService>(
          builder: (context, authState, _) {
            return FutureBuilder(       //ждем пока придет ответ getToken
              future: authState.getToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data != "" ? const MenuScreen() : const LoginScreen();
                } else {
                  return const LoginScreen();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
