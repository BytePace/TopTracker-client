import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_bytepace/src/features/login/view/login_screen.dart';
import 'package:tt_bytepace/src/features/menu/view/menu_screen.dart';
import 'package:tt_bytepace/src/features/login/services/auth_services.dart';

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
        ChangeNotifierProvider(create: (context) => AuthState()),
        // other providers
      ],
      builder: (context, child) => Scaffold(
        body: Consumer<AuthState>(
          builder: (context, authState, _) {

            return FutureBuilder(       //ждем пока придет ответ getToken
              future: authState.getToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print(snapshot.data); //token
                  return snapshot.data != "" ? MenuScreen() : LoginScreen();
                } else {
                  return LoginScreen();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
