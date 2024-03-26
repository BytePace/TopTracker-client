import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_bytepace/src/app.dart';
import 'package:tt_bytepace/src/features/login/services/auth_service.dart';
import 'package:tt_bytepace/src/features/menu/bloc/ProjectListBloc/project_list_bloc.dart';
import 'package:tt_bytepace/src/features/menu/services/project_service.dart';
import 'package:tt_bytepace/src/features/menu/services/users_services.dart';
import 'package:tt_bytepace/src/theme/light_mode.dart';

void main() {
  initGetIt();
  runApp(const MainApp());
}
void initGetIt(){
  GetIt.I.registerSingleton<ProjectService>(ProjectService());
  GetIt.I.registerSingleton<UserServices>(UserServices());
  GetIt.I.registerSingleton<ProjectListBloc>(ProjectListBloc(projectService: GetIt.I<ProjectService>(), userServices: GetIt.I<UserServices>()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return MaterialApp(theme: lightMode, home: App(authProvider: authService));
  }
}
