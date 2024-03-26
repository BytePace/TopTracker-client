import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_bytepace/src/features/login/services_provider/auth_provider.dart';
import 'package:tt_bytepace/src/features/login/view/login_screen.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';
import 'package:tt_bytepace/src/features/menu/view/menu_screen.dart';
import 'package:tt_bytepace/src/features/login/services/auth_service.dart';

class App extends StatefulWidget {
  final AuthProvider authProvider;
  const App({super.key, required this.authProvider});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late AuthService _authService;

  @override
  void initState() {
    _authService = widget.authProvider as AuthService;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _authService),
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
